import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/user_model/user.dart' as udanpani;
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/presentation/screens/auth_pages/otp.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/widgets/text_input_field.dart';
import 'package:udanpani/widgets/textforminput.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _nameEditingController = TextEditingController();
  final _phoneEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _phoneEditingController.dispose();
    _nameEditingController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);

    setState(() {
      if (im != null) {
        _image = im;
      }
    });
  }

  void _signUpUser() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are mandatory')),
      );

      return;
    }

    if (_phoneEditingController.text.trim().length != 10) {
      showSnackBar("Invalid phone number", context);
      return;
    }
    String phoneNumber = "+91" + _phoneEditingController.text.trim();

    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_emailEditingController.text)) {
      showSnackBar("Invalid email", context);
      return;
    }

    if (_image == null) {
      showSnackBar("No Image selected", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool isPhoneAlreadyRegistered =
        await FirestoreMethods().checkForPhone(phoneNumber);
    if (isPhoneAlreadyRegistered) {
      showSnackBar("Phone number already in use", context);

      setState(() {
        _isLoading = false;
      });
      return;
    }

    bool isEmailAlreadyRegistered = await FirestoreMethods()
        .checkForEmail(_emailEditingController.text.trim());
    if (isEmailAlreadyRegistered) {
      showSnackBar("Email already in use", context);

      setState(() {
        _isLoading = false;
      });
      return;
    }

    bool isUsernameAlreadyRegistered = await FirestoreMethods()
        .checkForUsername(_usernameEditingController.text.trim());
    if (isUsernameAlreadyRegistered) {
      showSnackBar("Username already in use", context);

      setState(() {
        _isLoading = false;
      });
      return;
    }

    UserCredential? userCredential = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(phoneNumber, isSignUp: true),
      ),
    );

    if (userCredential == null) {
      showSnackBar("OTP Verification failed", context);

      setState(() {
        _isLoading = false;
      });

      return;
    }

    String res = await AuthMethods().signUpUser(
      user: udanpani.User(
        name: _nameEditingController.text,
        username: _usernameEditingController.text,
        email: _emailEditingController.text.trim(),
        phoneNumber: phoneNumber,
        rating: 0,
        noOfReviews: 0,
        reviews: [],
      ),
      cred: userCredential,
      password: _passwordEditingController.text,
      file: _image,
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

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (_image != null)
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(_image!),
                        )
                      else
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg"),
                          radius: 60,
                        ),
                      Positioned(
                        bottom: -10,
                        right: 10,
                        height: 50,
                        child: FloatingActionButton(
                          onPressed: _selectImage,
                          child: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormInput(
                    textEditingController: _usernameEditingController,
                    hintText: "Username",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormInput(
                    textEditingController: _nameEditingController,
                    hintText: "Name",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormInput(
                    prefix: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "+91",
                      ),
                    ),
                    textEditingController: _phoneEditingController,
                    hintText: "Phone Number",
                    isNumber: true,
                    maxLength: 10,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextFormInput(
                    textEditingController: _emailEditingController,
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  //  TextFormInput(
                  //    textEditingController: _passwordEditingController,
                  //    hintText: "Password",
                  //    textInputType: TextInputType.text,
                  //    isPass: true,
                  //  ),
                  //  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _signUpUser,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : const Text("Sign up"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: const Text(
                          "Login now",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
