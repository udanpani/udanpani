/*
  Displays all the jobs listed by the user and allows them to add to the list
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/presentation/screens/op_job_actions_screen.dart';
import 'package:udanpani/services/firestore_service.dart';

import '../../../domain/models/job_model/job.dart';

class JobsListed extends StatefulWidget {
  const JobsListed({Key? key}) : super(key: key);

  @override
  State<JobsListed> createState() => _JobsListedState();
}

class _JobsListedState extends State<JobsListed> {
  List<Job>? _myJobs;

  @override
  void initState() {
    super.initState();
    _getMyJobs();
  }

  void _getMyJobs() async {
    List<Job> jobs = await FirestoreMethods().getMyJobs();
    print("GOT JOBS");

    if (!mounted) return;

    setState(() {
      _myJobs = jobs;
    });
  }

  void _navigateToAddNewScreen() {
    Navigator.pushNamed(context, '/upload').then((_) {
      _getMyJobs();
    });
  }

  _buildApplicationStatus(Job job) {
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

  _navigateToJobActions(Job job) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => JobActions(job: job)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 5),
              color: mobileBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Listed Jobs",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {},
                    splashRadius: 1,
                    icon: const Icon(Icons.history),
                  )
                ],
              ),
            ),
            Expanded(child: _listedJobs()),
          ],
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _navigateToAddNewScreen();
              },
              child: Icon(Icons.add),
            ))
      ]),
    );
  }

  Widget _listedJobs() {
    if (_myJobs != null) {
      if (_myJobs!.isEmpty) {
        return const Center(
          child: Text("Add a new job to see it listed here"),
        );
      }
      return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              foregroundImage: NetworkImage(_myJobs![index].photoUrl!),
            ),
            title: Text(_myJobs![index].title),
            trailing: _buildApplicationStatus(_myJobs![index]),
            onTap: () {
              _navigateToJobActions(_myJobs![index]);
            },
          );
        },
        itemCount: _myJobs!.length,
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
