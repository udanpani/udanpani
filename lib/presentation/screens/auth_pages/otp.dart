import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/widgets/text_input_field.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen(this.phoneNumber, {Key? key}) : super(key: key);
  String phoneNumber;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _otpeditingcontroller = TextEditingController();
  String? verificationCode;

  _verify() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          Navigator.pop(context, true);
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(e.message!, context);
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFieldInput(
              hintText: "OTP",
              textEditingController: _otpeditingcontroller,
              textInputType: TextInputType.number,
            ),
            ElevatedButton(
                onPressed: () {
                  try {
                    var phoneAuth = PhoneAuthProvider.credential(
                        verificationId: verificationCode!,
                        smsCode: _otpeditingcontroller.text);
                    if (phoneAuth != null) {
                      showSnackBar("OTP Valid", context);
                      Navigator.pop(context, true);
                    } else {
                      showSnackBar("Incorrect OTP", context);
                    }
                  } catch (e) {
                    showSnackBar(e.toString(), context);
                  }
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
