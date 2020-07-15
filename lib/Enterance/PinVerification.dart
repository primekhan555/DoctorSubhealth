import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subhealth_doctorapp/Enterance/InfoScreen.dart';
import 'package:subhealth_doctorapp/Enterance/ResetPassword.dart';
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;

final FirebaseAuth _auth = FirebaseAuth.instance;

class PinVerification extends StatefulWidget {
  final String number;
  final int status;
  PinVerification({Key key, this.number, this.status}) : super(key: key);

  @override
  _PinVerificationState createState() => _PinVerificationState();
}

class _PinVerificationState extends State<PinVerification> {
  final _smsController = TextEditingController();

  @override
  void initState() {
    _verifyPhoneNumber();
    super.initState();
  }

  String _verificationId;
  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential).then((currentUser) async {
        // globals.uid = currentUser.user.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString("uid", "${currentUser.user.uid}");
        prefs.setString("phone", "${widget.number}");
        if (widget.status == 1) {
          navigate.push(
              context,
              InfoScreen(
                number: widget.number,
              ));
        } else if (widget.status == 0) {
          navigate.push(
              context,
              ResetPassword(
                number: widget.number,
              ));
        }
        return currentUser.user;
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {};

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      SnackBar(
        content: Text("Please check your phone for the verification code"),
      );
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.number,
        timeout: const Duration(seconds: 50),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    // final FirebaseUser user =
    await _auth.signInWithCredential(credential).then((currentUser) async {
      globals.uid = currentUser.user.uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString("uid", "${currentUser.user.uid}");
      prefs.setString("phone", "${widget.number}");
      if (widget.status == 1) {
        navigate.push(
            context,
            InfoScreen(
              number: widget.number,
            ));
      } else if (widget.status == 0) {
        navigate.push(
            context,
            ResetPassword(
              number: widget.number,
            ));
      }
      return currentUser.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: colors.white,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/loginback.png"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 50),
                    height: 100,
                    child: assets.logo()),
                simple.text("NUMBER VERIFICATION",
                    color: colors.blue, fontSize: width * 0.08),
                simple.text("Waiting to automatically detect an SMS sent to",
                    color: colors.grey),
                simple.text(
                    "${(widget.number[0] + widget.number[1] + widget.number[2] + widget.number[3] + widget.number[4] + widget.number[5] + widget.number[6]).toString()}*******",
                    color: colors.blue,
                    fontSize: width * 0.05),
                Container(
                  padding: EdgeInsets.only(left: width / 3, right: width / 3),
                  margin: EdgeInsets.only(top: 25),
                  child: PinInputTextField(
                    onChanged: (value) {
                      if (value.length == 6) {
                        _signInWithPhoneNumber();
                      }
                    },
                    controller: _smsController,
                    enabled: true,
                    pinLength: 6,
                    keyboardType: TextInputType.phone,
                    autoFocus: false,
                    decoration: UnderlineDecoration(
                      textStyle: TextStyle(color: colors.blue, fontSize: 18),
                      color: colors.blue,
                      gapSpaces: [2, 2, 10, 2, 2],
                      obscureStyle: ObscureStyle(
                        isTextObscure: false,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 20,
                  child: Divider(
                    color: colors.blue,
                    indent: width / 3.2,
                    endIndent: width / 3.2,
                    thickness: 0.5,
                  ),
                ),
                simple.text("Enter the 6-digit code"),
                // Container(
                //   margin: EdgeInsets.only(top: height / 4.55),
                //   child: AButton(
                //     color: colors.pCyan,
                //     hei: height / 9,
                //     name: "Try Again",
                //     screen: SignIn(),
                //   ),
                // ),
              ],
            ),
          )),
    );
  }
}
