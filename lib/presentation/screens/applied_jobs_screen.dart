import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/presentation/screens/job_details_screen.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/widgets/loadingwidget.dart';

class AppliedJobsScreen extends StatefulWidget {
  const AppliedJobsScreen({Key? key}) : super(key: key);

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  late List<Job> _jobs;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAppliedJobs();
  }

  _getAppliedJobs() async {
    var jobs = await FirestoreMethods().getAppliedJobs();

    if (!mounted) return;

    setState(() {
      _jobs = jobs;
      _isLoading = false;
    });
  }

  _buildJobs() {
    if (_isLoading == true || _jobs == null) {
      return LoadingWidget();
    }

    if (_jobs.isEmpty) {
      return const Center(
        child: Text("No Jobs Applied."),
      );
    }

    _navigateToDetails(id) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobDetailsScreen(id: id),
        ),
      ).then((value) {
        _getAppliedJobs();
        setState(() {});
      });
    }

    _buildApplicationStatus(Job job) {
      if (job.status == "pending") {
        return const Icon(Icons.pending_outlined);
      } else if (job.acceptedApplicant !=
          FirebaseAuth.instance.currentUser!.uid) {
        return const Icon(
          Icons.clear,
          color: Colors.red,
        );
      }

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

    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(_jobs[index].title),
        trailing: _buildApplicationStatus(_jobs[index]),
        onTap: () {
          _navigateToDetails(_jobs[index].jobId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Applications"),
      ),
      body: SafeArea(
        child: _buildJobs(),
      ),
    );
  }
}
