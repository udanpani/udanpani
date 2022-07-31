import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/presentation/screens/auth_pages/otp.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/widgets/text_input_field.dart';
import 'package:udanpani/widgets/textforminput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_phoneEditingController.text.trim().length != 10) {
      showSnackBar("Invalid phone number", context);
      return;
    }

    String phoneNumber = "+91" + _phoneEditingController.text.trim();

    setState(() {
      _isLoading = true;
    });

    bool isRegistered = await FirestoreMethods().checkForPhone(phoneNumber);
    if (!isRegistered) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar("No such user, please sign up", context);
      return;
    }

    PhoneAuthCredential _phoneCred = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => OTPScreen(phoneNumber)));

    // if not verified
    if (_phoneCred == null) {
      showSnackBar("Cannot validate", context);

      setState(() {
        _isLoading = false;
      });

      return;
    }

    // String res = await AuthMethods().loginUser(
    //   credential: _phoneCred,
    // );

    setState(() {
      _isLoading = false;
    });

    //if (res == 'success') {
    //  Navigator.pushReplacementNamed(context, '/home');
    //} else {
    //  showSnackBar(res, context);
    //}
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //todo logo

                const SizedBox(
                  height: 60,
                ),

                TextFormInput(
                  textEditingController: _phoneEditingController,
                  prefix: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      "+91",
                    ),
                  ),
                  hintText: "Phone",
                  textInputType: TextInputType.number,
                  isNumber: true,
                ),

                //  TextFormInput(
                //    textEditingController: _passwordEditingController,
                //    hintText: "Password",
                //    textInputType: TextInputType.text,
                //    isPass: true,
                //  ),
                SizedBox(
                  height: 20,
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
