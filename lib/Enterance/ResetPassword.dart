import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/APIsModels/ResetPasswordM.dart';
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;

class ResetPassword extends StatefulWidget {
  final String number;
  ResetPassword({Key key, this.number}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String password, cPassword;
  String error = "";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/loginback.png"),
                  fit: BoxFit.cover)),
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Column(
            children: <Widget>[
              assets.logoCont(marginBottom: 15),
              textField("New Password", "password"),
              // simple.text("text"),
              textField("Confirm Password", "cPassword"),
              simple.text("$error", color: colors.red),
              Container(
                width: width,
                height: 40,
                margin: EdgeInsets.only(top: 20),
                child: OutlineButton(
                  borderSide: BorderSide(color: colors.blue, width: 1.5),
                  onPressed: password != null &&
                          cPassword != null &&
                          password.isNotEmpty &&
                          cPassword.isNotEmpty &&
                          password == cPassword
                      ? () async {
                          String url =
                              "${globals.baseUrl}api/app/auth/resetpassword";
                          Map<String, String> headers = {
                            "Content-type": "application/json"
                          };
                          final reset = ResetPasswordM(
                              mobile: widget.number, newPassword: password);
                          var res = await http
                              .post(url,
                                  headers: headers,
                                  body: json.encode(reset.body()))
                              .catchError((error) => alert.showFlushbar(
                                  "Server Down", context, colors.red));
                          if (res.statusCode == 200) {
                            var decoded = json.decode(res.body);
                          }
                        }
                      : null,
                  child: simple.text("Reset Password", color: colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  textField(String hint, String type) {
    return Container(
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(hintText: "$hint"),
        onChanged: (value) {
          setState(() {
            if (type == "password") {
              password = value;
            } else {
              cPassword = value;
              if (password != cPassword) {
                error = "Password is not matching";
              } else {
                error = "";
              }
            }
          });
        },
      ),
    );
  }
}
