import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/presentation/screens/auth_pages/login_screen.dart';
import 'package:udanpani/presentation/screens/auth_pages/signup_screen.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/widgets/showSnackbar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  _signout(context) async {
    String res = await AuthMethods().signoutUser();
    if (res != "success") {
      showSnackbar(context, res);

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _signout(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
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
        ),
      ),
    );
  }
}
