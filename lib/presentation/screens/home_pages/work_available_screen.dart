import 'package:flutter/material.dart';
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

  void showDetails(
      /* takes in job */ int
          index /* showing that data is being transferred*/) {
    Navigator.pushNamed(
      context,
      '/job',
      arguments: index,
    );
  }

  Widget availableWork() {
    return ListView.separated(
      itemCount: 50,
      itemBuilder: ((context, index) {
        return ListTile(
          onTap: () {
            showDetails(index);
          },
          leading: const CircleAvatar(backgroundColor: primaryColor),
          title: Text("TITLE ${index}"),
          subtitle: const Text("Location"),
          trailing: const Text("000"),
        );
      }),
      separatorBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: secondaryColor,
            ),
          )),
    );
  }
}
