import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subhealth_doctorapp/APIsModels/Login.dart';
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/Enterance/Registeration.dart';
import 'package:subhealth_doctorapp/MainSection/MainScreen.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String number, password;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Column(
            children: <Widget>[
              assets.logoCont(height: 100),
              Form(
                  key: _formKey,
                  autovalidate: _autovalidate,
                  child: Column(
                    children: <Widget>[
                      textField("Phone Number", TextInputType.number, false,
                          "username", 10),
                      textField(
                          "Password", TextInputType.text, true, "password", 30),
                      simple.container(
                          simple.text("Forgot password ?",
                              color: colors.blue, fontSize: 14),
                          20,
                          width,
                          margin: 20,
                          alignment: Alignment.centerRight),
                      Container(
                        width: width,
                        height: 45,
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.all(1),
                        child: OutlineButton(
                          borderSide:
                              BorderSide(color: colors.blue, width: 1.5),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              String fullnumber = "+92$number";

                              String url =
                                  "${globals.baseUrl}api/app/auth/login";
                              Map<String, String> headers = {
                                "Content-type": "application/json"
                              };

                              final login = Login(
                                  username: fullnumber,
                                  password: this.password);
                              if (fullnumber.length == 13) {
                                log("message");

                                var res = await http
                                    .post(url,
                                        headers: headers,
                                        body: json.encode(login.body()))
                                    .catchError((error) => alert.showFlushbar(
                                        "Server Down", context, colors.red));
                                log("${res.statusCode}");
                                if (res.statusCode == 201) {
                                  var decoded = json.decode(res.body);
                                  if (decoded["status"] == 1) {
                                    log("${decoded["user"]}");
                                    // printWrapped("${decoded}");
                                    // navigate.pushRemove(context, MainScreen());
                                  } else if (decoded["status"] == 2) {
                                    //go to patient
                                  }
                                } else
                                  alert.showFlushbar(
                                      "Account does not exist. please Sign up",
                                      context,
                                      colors.red);
                              }
                            } else
                              _autovalidate = true;
                          },
                          child: simple.text(
                            "LOGIN",
                            color: colors.blue,
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: <Widget>[
                              simple.text("Don't have an account? "),
                              InkWell(
                                onTap: () => navigate.pushRemove(
                                    context, Registeration()),
                                child: simple.text("Sign up",
                                    color: colors.blue,
                                    fontWeight: FontWeight.w900),
                              )
                            ],
                          ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  textField(String hint, TextInputType keyboardType, bool obscureText,
          String type, int maxLength) =>
      Container(
        margin: EdgeInsets.only(top: 10),
        child: TextFormField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(hintText: hint, counterText: ""),
          validator: (value) {
            if (value == null || value.isEmpty) {
              if (type == "username")
                return "Enter your Phone Number";
              else
                return "Enter your Password";
            }
            return null;
          },
          onChanged: (value) {
            type == "username" ? number = value : password = value;
          },
        ),
      );
}
