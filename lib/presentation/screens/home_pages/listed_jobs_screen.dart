/*
  Displays all the jobs listed by the user and allows them to add to the list
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:udanpani/core/colors.dart';
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

  void navigateToAddNewScreen() {
    Navigator.pushNamed(context, '/upload').then((_) {
      _getMyJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listedJobs(),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddNewScreen,
        child: const Icon(Icons.add),
      ),
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
            title: Text(_myJobs![index].title),
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
