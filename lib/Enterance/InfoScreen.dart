import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subhealth_doctorapp/APIsModels/UserName.dart';
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/Enterance/InfoScreen2.dart';
import 'package:subhealth_doctorapp/Enterance/Registeration.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:http/http.dart' as http;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'dart:developer';

class InfoScreen extends StatefulWidget {
  final String number;
  InfoScreen({Key key, this.number}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final focus = FocusNode();
  final focus1 = FocusNode();
  String fullName, userName, cnic, password, cPassword;
  final _formKey = GlobalKey<FormState>();
  bool enable = false;
  Color docColor = colors.lightGrey;
  Color docTColor = colors.blue;
  Color patColor = colors.lightGrey;
  Color patTColor = colors.blue;
  String role = "none";
  bool _autoValidate = false;
  String userNameError = "";
  double userNameEheight = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: () => navigate.pushRemove(context, Registeration()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 45, right: 45),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 50, top: 100),
                      height: 100,
                      child: assets.logo()),
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            log("hello world");
                            setState(() {
                              if (!enable) {
                                enable = true;
                              }
                              role = "1";
                              docColor = colors.blue;
                              docTColor = colors.lightGrey;
                              patColor = colors.lightGrey;
                              patTColor = colors.blue;
                            });
                          },
                          color: docColor,
                          child: simple.text("Doctor", color: docTColor),
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (!enable) {
                                enable = true;
                              }
                              role = "2";
                              docColor = colors.lightGrey;
                              docTColor = colors.blue;
                              patColor = colors.blue;
                              patTColor = colors.lightGrey;
                            });
                          },
                          color: patColor,
                          child: simple.text("Patient", color: patTColor),
                        )
                      ],
                    ),
                  ),
                  simple.container(simple.text("${widget.number}"), 20, width,
                      margin: 20),
                  Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                        children: <Widget>[
                          textField(
                              "Full Name", TextInputType.text, 30, "fullname"),
                          textField(
                              "Username", TextInputType.text, 30, "username"),
                          simple.container(
                              simple.text("$userNameError", color: colors.red),
                              userNameEheight,
                              width),
                          // textField(
                          //     "Email", TextInputType.emailAddress, 30, "email"),
                          textField("Cnic", TextInputType.number, 13, "cnic"),
                          textField(
                              "Password", TextInputType.text, 50, "password",
                              obscureText: true),
                          textField("Confirm Password", TextInputType.text, 50,
                              "cpassword",
                              obscureText: true),
                        ],
                      )),
                  Container(
                    width: width,
                    height: 50,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 1, right: 1, bottom: 1),
                    child: OutlineButton(
                      borderSide: BorderSide(color: colors.blue, width: 2),
                      onPressed: !enable
                          ? null
                          : () {
                              debugPrint("object");
                              setState(() => _autoValidate = true);
                              if (cnic != null) {
                                if (cnic.length < 13)
                                  return alert.showFlushbar(
                                      "Cnic length must be 13 character ",
                                      context,
                                      colors.red);
                              }
                              if (password != null) {
                                if (password.length < 9)
                                  return alert.showFlushbar(
                                      "Password length must be 8 character",
                                      context,
                                      colors.red);
                              }
                              if (password != cPassword)
                                return alert.showFlushbar(
                                    "Passwords are not matching",
                                    context,
                                    colors.red);

                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (userNameEheight == 0) {
                                  navigate.push(
                                      context,
                                      InfoScreen2(
                                        role: this.role,
                                        number: widget.number,
                                        fullName: this.fullName,
                                        // email: this.email,
                                        userName: this.userName,
                                        cnic: this.cnic,
                                        password: this.password,
                                      ));
                                } else {
                                  alert.showFlushbar("Try a different username",
                                      context, colors.red);
                                }
                              }
                            },
                      child:
                          simple.text("NEXT", color: colors.blue, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  textField(
      String hintText, TextInputType keyboardType, int maxLength, String type,
      {obscureText}) {
    return Container(
      child: TextFormField(
        enabled: enable,
        maxLength: maxLength,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(hintText: hintText, counterText: ""),
        onEditingComplete: () {
          log("dfasfsd");
          FocusScope.of(context).requestFocus(FocusNode());
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (type == "fullname")
              return "Please Enter Full Name";
            else if (type == "username")
              return "Please Enter Username";
            // else if (type == "email")
            //   return "Please Enter Email";
            else if (type == "cnic")
              return "Please Enter CNIC";
            else if (type == "password")
              return "Please Enter Password";
            else if (type == "cpassword")
              return "Please Confirm your Password";
            else
              return null;
          }
          return null;
        },
        onChanged: (value) {
          if (type == "username") {
            checkUserName(value);
          }

          type == "fullname"
              ? fullName = value
              : type == "username"
                  ? userName = value
                  : type == "cnic"
                      ? cnic = value
                      : type == "password"
                          ? password = value
                          : cPassword = value;
        },
      ),
    );
  }

  checkUserName(String userName) async {
    log("$userName");
    setState(() {
      if (userNameEheight != 0) {
        userNameEheight = 0;
        userNameError = "";
      }
    });

    String url = "${globals.baseUrl}api/app/auth/checkusername";
    var check = UserName(userName: userName);
    Map<String, String> headers = {"Content-type": "application/json"};
    var res =
        await http.post(url, headers: headers, body: json.encode(check.body()));
    var decoded = json.decode(res.body);
    if (decoded["status"] == 0) {
      setState(() {
        userNameEheight = 20;
        userNameError = decoded["message"];
      });
    } else {
      this.userName = userName;
    }
  }
}
