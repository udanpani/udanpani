import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pinput/pinput.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/presentation/resposive/mobile_layout.dart';
import 'package:udanpani/presentation/resposive/responsive_screen.dart';
import 'package:udanpani/presentation/resposive/web_screen_layout.dart';
import 'package:udanpani/services/auth_methods.dart';
import 'package:udanpani/widgets/loadingwidget.dart';
import 'package:udanpani/widgets/text_input_field.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen(this.phoneNumber, {Key? key, this.isSignUp = false})
      : super(key: key);

  String phoneNumber;
  bool isSignUp;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _otpeditingcontroller = TextEditingController();
  String? verificationCode;

  bool _isLoading = true;

  _verify() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          _loginUser(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(e.message!, context);
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            verificationCode = verificationID;
            _isLoading = false;
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

  _loginUser(PhoneAuthCredential phoneAuth) async {
    List loginReturns = await AuthMethods().loginUser(
      credential: phoneAuth,
    );

    String res = loginReturns[0];

    UserCredential? cred = loginReturns[1];

    if (res == 'success') {
      if (widget.isSignUp) {
        Navigator.pop(context, cred);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              ),
            ),
            (route) => false);
      }
    } else {
      showSnackBar(res, context);
      return;
    }
  }

  _completedOTP(String pin) async {
    try {
      var phoneAuth = PhoneAuthProvider.credential(
          verificationId: verificationCode!, smsCode: pin.trim());
      _loginUser(phoneAuth);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _isLoading
                ? [
                    LoadingWidget(),
                    const SizedBox(height: 10),
                    Text("Sending OTP to ${widget.phoneNumber}")
                  ]
                : [
                    Text(
                      "ENTER OTP",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Pinput(
                      length: 6,
                      hapticFeedbackType: HapticFeedbackType.heavyImpact,
                      onCompleted: (pin) => _completedOTP(pin),
                    ),
                  ],
          ),
        ),
      )),
    );
  }
}
