import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/domain/models/user_model/user.dart';
import 'package:udanpani/infrastructure/utils.dart';
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

  @override
  void initState() {
    super.initState();
    _getApplicants();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getApplicants() async {
    setState(() {
      isApplicantsLoading = true;
    });
    if (widget.job.applicants == null) {
      applicants = [];
      setState(() {
        isApplicantsLoading = false;
      });
      return;
    }

    if (widget.job.acceptedApplicant != null) {
      _acceptedApplicant =
          await FirestoreMethods().getUser(widget.job.acceptedApplicant!);
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
      case "pending":
        return const Icon(Icons.more_horiz);
      case "accepted":
        return const Icon(Icons.done);
      case "in progress":
        return const Icon(Icons.access_time);
      case "completed":
        return const Icon(
          Icons.task_alt,
          color: Colors.green,
        );
    }
  }

  _buildApplicants() {
    if (widget.job.acceptedApplicant != null) {
      return ListTile(
        title: Text(_acceptedApplicant!.username),
        trailing: _showApplicationStatus(),
      );
    }

    if (applicants.isEmpty) {
      return Text("No applications yet");
    }

    return ListView.builder(
      itemCount: widget.job.applicants!.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(applicants[index].name),
        trailing: ElevatedButton(
          child: Text("Accept"),
          onPressed: () {
            _acceptApplicant(applicants[index].uid!);
          },
        ),
      ),
    );
  }

  _acceptApplicant(String uid) async {
    setState(() {
      isApplicantsLoading = true;
    });

    String res = await FirestoreMethods()
        .acceptApplicant(jobID: widget.job.jobId!, applicantID: uid);

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
        title: Text("Manage Job"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
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
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.job.description,
              ),
              const SizedBox(height: 20),
              Text(
                "Applicants: ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
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
