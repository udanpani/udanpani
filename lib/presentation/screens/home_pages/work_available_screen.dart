import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:udanpani/core/colors.dart';

class WorkAvailable extends StatefulWidget {
  const WorkAvailable({Key? key}) : super(key: key);

  @override
  State<WorkAvailable> createState() => _WorkAvailableState();
}

class _WorkAvailableState extends State<WorkAvailable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: availableWork(),
    );
  }

  Widget availableWork() {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: ((context, index) {
        return ListTile(
          leading: const CircleAvatar(backgroundColor: primaryColor),
          title: Text("TITLE ${index}"),
          subtitle: const Text("Location"),
          trailing: const Text("000"),
        );
      }),
    );
  }
}
