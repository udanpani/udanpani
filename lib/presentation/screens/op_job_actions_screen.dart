import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/domain/models/review/review.dart';
import 'package:udanpani/domain/models/user_model/user.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/presentation/screens/home_pages/profile_screen.dart';
import 'package:udanpani/presentation/screens/show_profile.dart';
import 'package:udanpani/services/firestore_service.dart';

class JobActions extends StatefulWidget {
  JobActions({
    Key? key,
    required this.job,
  }) : super(key: key);

  Job job;
  @override
  State<JobActions> createState() => _JobActionsState();
}

class _JobActionsState extends State<JobActions> {
  bool isApplicantsLoading = true;
  List<User> applicants = [];
  User? _acceptedApplicant;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _getApplicants();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _refreshJob() async {
    Job job = await FirestoreMethods().getJob(widget.job.jobId!);
    setState(() {
      widget.job = job;
    });
  }

  _getReviews() async {
    setState(() {
      isApplicantsLoading = true;
    });
    List<Review> reviews =
        await FirestoreMethods().getReviewsForJob(widget.job.jobId!);

    setState(() {
      isApplicantsLoading = false;
      _reviews = reviews;
    });
  }

  _getApplicants() async {
    setState(() {
      isApplicantsLoading = true;
    });

    if (widget.job.status == "completed") {
      _getReviews();
    }
    if (_acceptedApplicant != null) {
      setState(() {});
    }

    if (widget.job.acceptedApplicant != null) {
      _acceptedApplicant =
          await FirestoreMethods().getUser(widget.job.acceptedApplicant!);

      setState(() {
        isApplicantsLoading = false;
      });
      return;
    }

    if (widget.job.applicants == null) {
      applicants = [];
      setState(() {
        isApplicantsLoading = false;
      });
      return;
    }
    for (var applicant in widget.job.applicants!) {
      final user = await FirestoreMethods().getUser(applicant);
      applicants.add(user);
    }

    setState(() {
      isApplicantsLoading = false;
    });
  }

  _showApplicationStatus() {
    final job = widget.job;
    switch (job.status) {
      case "accepted":
        return const Icon(
          Icons.task_alt,
          color: Colors.green,
        );
      case "in progress":
        return const Icon(Icons.access_time);
      case "paid":
        return const Icon(Icons.done);
      case "completed":
        return const Icon(
          Icons.done_all,
          color: Colors.green,
        );
    }
  }

  _buildApplicants() {
    if (widget.job.status == "paid") {
      return Center(
        child: ElevatedButton(
            onPressed: () {
              _showReviewDialog();
            },
            child: const Text("Leave a review")),
      );
    }

    if (widget.job.status == "completed") {
      return Center(
        child: _buildReviews(),
      );
    }

    if (widget.job.acceptedApplicant != null || _acceptedApplicant != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(_acceptedApplicant!.username),
            trailing: _showApplicationStatus(),
          ),

          // to do change with phone
          Text(_acceptedApplicant!.email),
          const SizedBox(
            height: 10,
          ),
          const Text(
            " ⚠️ Make sure to ask the worker to mark \"payment received\" upon payment",
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (applicants.isEmpty) {
      return const Text("No applications yet");
    }

    return ListView.builder(
      itemCount: widget.job.applicants!.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
          applicants[index].profilePicture!,
        )),
        title: Text(applicants[index].username),
        trailing: ElevatedButton(
          child: const Text("Accept"),
          onPressed: () {
            _acceptApplicant(applicants[index].uid!);
          },
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ShowProfileScreen(uid: applicants[index].uid!)));
        },
      ),
    );
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

  _showReviewDialog() {
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
          response.comment = "";
          return;
        }
        String res = await FirestoreMethods().sendReview(
            stars: response.rating,
            comment: response.comment,
            reviewerUid: widget.job.posterUid,
            reviewedUid: widget.job.acceptedApplicant!,
            jobID: widget.job.jobId!,
            status: "completed",
            reviewer: 1);

        if (res != "success") {
          showSnackBar(res, context);
        } else {
          _refreshJob();
          await _getReviews();
          showSnackBar(res, context);
        }
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

  _acceptApplicant(String uid) async {
    setState(() {
      isApplicantsLoading = true;
    });

    String res = await FirestoreMethods()
        .acceptApplicant(jobID: widget.job.jobId!, applicantID: uid);
    _acceptedApplicant = await FirestoreMethods().getUser(uid);
    _getApplicants();

    setState(() {
      isApplicantsLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Job"),
        actions: [
          (widget.job.status == "pending")
              ? IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Text(widget.job.status.toUpperCase())),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  widget.job.photoUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.job.title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Expected wage: ₹${widget.job.price}",
              ),
              const SizedBox(height: 10),
              Text(
                widget.job.description,
              ),
              const SizedBox(height: 20),
              const Text(
                "Applicants: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: blueColor,
                  ),
                ),
                child: isApplicantsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildApplicants(),
              )
            ],
          ),
        ),
      )),
    );
  }
}
