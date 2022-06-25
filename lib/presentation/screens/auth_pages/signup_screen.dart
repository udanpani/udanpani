import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/domain/models/user_model/user.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void _signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      user: User(
        username: _usernameEditingController.text,
        email: _emailEditingController.text,
        password: _passwordEditingController.text,
      ),
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
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 38),
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
                      child: Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              TextFieldInput(
                textEditingController: _usernameEditingController,
                hintText: "Username",
                textInputType: TextInputType.text,
              ),
              TextFieldInput(
                textEditingController: _emailEditingController,
                hintText: "Email",
                textInputType: TextInputType.emailAddress,
              ),
              TextFieldInput(
                textEditingController: _passwordEditingController,
                hintText: "Password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
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
    );
  }
}
