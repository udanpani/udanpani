import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/widgets/text_input_field.dart';
import 'package:udanpani/widgets/textforminput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailEditingController.text.trim(),
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
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //todo logo

                const SizedBox(
                  height: 60,
                ),

                TextFormInput(
                    textEditingController: _emailEditingController,
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress),

                TextFormInput(
                  textEditingController: _passwordEditingController,
                  hintText: "Password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),

                ElevatedButton(
                  onPressed: _loginUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : const Text("Login"),
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
      ),
    );
  }
}
