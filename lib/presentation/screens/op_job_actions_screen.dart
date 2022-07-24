import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class JobActions extends StatelessWidget {
  const JobActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Preview"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: SafeArea(child: Text("OP sees this page")),
    );
  }
}
