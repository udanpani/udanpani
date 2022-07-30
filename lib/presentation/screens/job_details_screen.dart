import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/domain/models/review/review.dart';
import 'package:udanpani/domain/models/user_model/user.dart' as udanpani;
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/services/rest_services.dart';
import 'package:udanpani/widgets/loadingwidget.dart';
import 'package:udanpani/widgets/text_input_field.dart';
import 'package:uuid/uuid.dart';

class JobDetailsScreen extends StatefulWidget {
  JobDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  String id;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _isLoading = true;
  Job? _job;
  bool _alreadyApplied = false;
  bool? _jobPending;
  bool? _isAccepted;
  udanpani.User? _jobPoster;
  List<Review> _reviews = [];

  final _locEditingController = TextEditingController(text: "Searching");
  Coordinates? _coordinates;

  late GoogleMapController _mapController;
  final Set<Marker> _mapMarkers = {};

  @override
  void initState() {
    super.initState();

    _getDetails();
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!mounted) return;
    setState(() {
      _mapController = controller;
    });
    if (_mapController != null) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(_coordinates!.latitude, _coordinates!.longitude), 18));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locEditingController.dispose();
    _mapController.dispose();
  }

  void _setMarker(LatLng coordinates) {
    _mapMarkers.clear();
    _coordinates = Coordinates(coordinates.latitude, coordinates.longitude);
    setState(() {
      _mapMarkers.add(
        Marker(
          markerId: MarkerId(const Uuid().v1()),
          position: coordinates,
        ),
      );
    });
  }

  Future<void> _getDetails() async {
    String id = widget.id;

    final job = await FirestoreMethods().getJob(id);
    if (job == null) {
      showSnackBar("Job returned null.", context);
      return;
    }

    final jobPoster = await FirestoreMethods().getUser(job.posterUid);

    double lat = ((job.geoHash as Map<String, dynamic>)["geopoint"] as GeoPoint)
        .latitude;
    double lon = ((job.geoHash as Map<String, dynamic>)["geopoint"] as GeoPoint)
        .longitude;
    _setMarker(LatLng(lat, lon));

    bool alreadyApplied = false;

    if (job.applicants != null &&
        job.applicants!.contains(FirebaseAuth.instance.currentUser!.uid)) {
      alreadyApplied = true;
    }

    setState(() {
      _isLoading = false;
      _job = job;
      _jobPending = job.status == "pending";
      _isAccepted = job.acceptedApplicant != null &&
          job.acceptedApplicant == FirebaseAuth.instance.currentUser!.uid;
      _alreadyApplied = alreadyApplied;
      _jobPoster = jobPoster;
    });

    if (job.status == "completed") {
      _getReviews();
    }
  }

  Future<void> _acceptJob() async {
    setState(() {
      _isLoading = true;
    });
    String res = await FirestoreMethods().acceptJob(widget.id);

    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);

      return;
    }

    Navigator.pop(context);
  }

  Future<void> _withdrawJob({bool afterAccept = false}) async {
    String res = await FirestoreMethods()
        .withdrawJob(widget.id, afterAccept: afterAccept);
    if (res != "success") {
      showSnackBar(res, context);
      return;
    }

    Navigator.pop(context);
  }

  _startJob() async {
    setState(() {
      _isLoading = true;
    });

    String res = await FirestoreMethods()
        .updateJobStatus(jobID: widget.id, status: "in progress");
    if (res != "success") {
      showSnackBar(res, context);

      setState(() {
        _isLoading = false;
      });

      return;
    }

    _getDetails();

    setState(() {
      _isLoading = false;
    });
  }

  _markAsPaid() async {
    setState(() {
      _isLoading = true;
    });

    String res = await FirestoreMethods()
        .updateJobStatus(jobID: widget.id, status: "paid");
    if (res != "success") {
      showSnackBar(res, context);

      setState(() {
        _isLoading = false;
      });

      return;
    }

    _getDetails();

    setState(() {
      _isLoading = false;
    });
  }

  _buildAcceptedDetails() {
    if (_jobPending! || !_isAccepted!) {
      return SizedBox(
        height: 10,
      );
    }

    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: blueColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _acceptedWidget(),
        ));
  }

  Widget _details() {
    if (_job == null) {
      return Center(
        child: Column(
          children: const [
            Icon(Icons.clear),
            Text("Something went wrong."),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Image(
              image: NetworkImage(_job!.photoUrl!),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            _job!.title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            _jobPoster!.username,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Text(
            "Expected wage: ₹${_job!.price}",
          ),
          const SizedBox(height: 20),
          Text(
            _job!.description,
          ),
          // if not accepted returns a sizedbox
          // if accepted, shows start work / mark payment received
          _buildAcceptedDetails(),

          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.142, -110.321),
                zoom: 15,
              ),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onMapCreated: _onMapCreated,
              tiltGesturesEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              markers: _mapMarkers,
            ),
          ),
        ],
      ),
    );
  }

  _acceptedWidget() {
    switch (_job!.status) {
      case "accepted":
        return [
          Text("Accepted"),
          Text("Expect a call from the employer anytime"),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Are you sure you want to start?"),
                          content: const Text(
                              "Once started, you cannot withdraw the application and are expected to complete in given time"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _startJob();
                                  Navigator.pop(context);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                          ],
                        ));
              },
              child: const Text("Start Job")),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title:
                              const Text("Are you sure you want to withdraw?"),
                          content: const Text(
                              "Withdrawing can impact your ratings."),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _withdrawJob(afterAccept: true);
                                  Navigator.pop(context);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                          ],
                        ));
              },
              child: const Text("Withdraw")),
        ];
      case "in progress":
        return [
          Text("In Progress"),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                              "Are you sure you want to mark as Completed and Payment Received?"),
                          content: const Text(
                              "By clicking yes, you agree that you've completed the job and received payment"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _markAsPaid();
                                  Navigator.pop(context);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                          ],
                        ));
              },
              child: const Text("Mark as Completed and Payment Received"))
        ];
      case "paid":
        if (_job!.workerReviewed) {
          return const [Text("Waiting for confirmation from employer")];
        }
        return [
          ElevatedButton(
              onPressed: () {
                _showReview();
              },
              child: const Text("Leave a review")),
        ];
      case "completed":
        return [
          Expanded(
            child: _buildReviews(),
          )
        ];
      default:
        return Text("Some error occured");
    }
  }

  _buildStars(double stars,
      {MainAxisAlignment alignment = MainAxisAlignment.center}) {
    int i = 0;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (i = 0; i < stars; i++) Icon(Icons.star),
        for (; i < 5; i++) Icon(Icons.star_border_outlined, color: Colors.grey),
        const SizedBox(
          width: 5,
        ),
        Text("$stars / 5"),
      ],
    );
  }

  _buildReviews() {
    if (_reviews.length == 0) {
      return Text("No Reviews");
    }
    return Center(
      child: ListView.builder(
          itemCount: _reviews.length,
          itemBuilder: (context, index) => ListTile(
                tileColor: Color.fromARGB(31, 206, 202, 202),
                isThreeLine: true,
                title: _buildStars(_reviews[index].rating,
                    alignment: MainAxisAlignment.start),
                subtitle: Text(_reviews[index].review +
                    "\n - ${_reviews[index].reviewerUname}"),
              )),
    );
  }

  _getReviews() async {
    setState(() {
      _isLoading = true;
    });
    List<Review> reviews =
        await FirestoreMethods().getReviewsForJob(_job!.jobId!);

    setState(() {
      _isLoading = false;
      _reviews = reviews;
    });
  }

  _showReview() {
    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: const Text(
        'Leave a review',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating. ',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: const FlutterLogo(size: 100),
      submitButtonText: 'Submit',
      commentHint: 'Write a review',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        if (response.comment == null || response.comment.isEmpty) {
          showSnackBar("Write something", context);
          return;
        }
        String res = await FirestoreMethods().sendReview(
            stars: response.rating,
            comment: response.comment,
            reviewerUid: _job!.acceptedApplicant!,
            reviewedUid: _job!.posterUid,
            jobID: _job!.jobId!,
            reviewer: 0);

        if (res != "success") {
          showSnackBar(res, context);
        } else {
          showSnackBar(res, context);
        }

        _getDetails();
        _getReviews();
        return;
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          !_isLoading
              ? _jobPending!
                  ? TextButton(
                      onPressed: () {
                        if (!_alreadyApplied) {
                          _acceptJob();
                          return;
                        }
                        _withdrawJob();
                      },
                      child: Text(
                        !_alreadyApplied ? "Accept" : "Withdraw",
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(20),
                      child: Text(_isAccepted!
                          ? _job!.status.toUpperCase()
                          : "REJECTED"))
              : const Icon(Icons.clear),
        ],
        title: const Text("Job Details"),
        backgroundColor: primaryColor.withOpacity(0.1),
      ),
      body: _isLoading
          ? LoadingWidget()
          : SingleChildScrollView(
              child: _details(),
            ),
    );
  }
}
