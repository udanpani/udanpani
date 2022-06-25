import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udanpani/core/colors.dart';

class JobsListed extends StatefulWidget {
  const JobsListed({Key? key}) : super(key: key);

  @override
  State<JobsListed> createState() => _JobsListedState();
}

class _JobsListedState extends State<JobsListed> {
  void navigateToAddNewScreen() {
    Navigator.pushNamed(context, '/upload');
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
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(backgroundColor: primaryColor),
        title: Text("Job $index"),
        subtitle: Text("location"),
        trailing: Text("000"),
      ),
    );
  }
}
