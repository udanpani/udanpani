import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/services/rest_services.dart';
import 'package:udanpani/widgets/loadingwidget.dart';
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
      _alreadyApplied = alreadyApplied;
    });
  }

  Future<void> _acceptJob() async {
    String res = await FirestoreMethods().acceptJob(widget.id);
    if (res != "success") {
      showSnackBar(res, context);
      return;
    }

    Navigator.pop(context);
  }

  Future<void> _withdrawJob() async {
    String res = await FirestoreMethods().withdrawJob(widget.id);
    if (res != "success") {
      showSnackBar(res, context);
      return;
    }

    Navigator.pop(context);
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
          const SizedBox(height: 20),
          Text(
            _job!.description,
          ),
          const SizedBox(height: 20),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          !_isLoading
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
              : const Icon(Icons.clear),
        ],
        title: Text("Job Details"),
        backgroundColor: primaryColor.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        child: _isLoading ? LoadingWidget() : _details(),
      ),
    );
  }
}
