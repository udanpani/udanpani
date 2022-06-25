import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    );
    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnackBar(res, context);
    }
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //todo logo

              const SizedBox(
                height: 60,
              ),

              TextFieldInput(
                  textEditingController: _emailEditingController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress),

              TextFieldInput(
                textEditingController: _passwordEditingController,
                hintText: "Password",
                textInputType: TextInputType.text,
                isPass: true,
              ),

              ElevatedButton(
                onPressed: _loginUser,
                child: const Text("Login"),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: _navigateToSignup,
                    child: const Text(
                      "Sign up now",
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
