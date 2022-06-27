import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          backgroundColor: primaryColor,
          radius: 60,
        ),
        SizedBox(
          height: 50,
        ),
        Text("NAME"),
        SizedBox(
          height: 10,
        ),
        Text("Location"),
        SizedBox(
          height: 30,
        ),
        Text("STARS : *****"),
      ],
    );
  }
}
