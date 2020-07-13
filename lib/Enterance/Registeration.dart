import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subhealth_doctorapp/Enterance/PinVerification.dart';
import 'package:subhealth_doctorapp/Enterance/SignIn.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:subhealth_doctorapp/APIsModels/Register.dart';
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;

class Registeration extends StatefulWidget {
  Registeration({Key key}) : super(key: key);

  @override
  _RegisterationState createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  final _formKey = GlobalKey<FormState>();
  String number = "1";
  bool _autovalidate = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 50, bottom: 50),
                  height: 100,
                  child: assets.logo()),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: colors.lightGrey),
                    borderRadius: BorderRadius.circular(8)),
                child: Form(
                  key: _formKey,
                  autovalidate: _autovalidate,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        number = value;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, right: 20),
                        counterText: "",
                        hintText: "Phone Number (3450123456)",
                        border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 45,
                  width: width,
                  child: OutlineButton(
                    borderSide: BorderSide(color: colors.blue, width: 1.5),
                    onPressed: number.length == 10
                        ? () async {
                            if (_formKey.currentState.validate()) {
                              String fullnmber = "+92$number";
                              number = "1";
                              String url =
                                  "${globals.baseUrl}api/app/auth/isNumber";
                              Map<String, String> headers = {
                                "Content-type": "application/json"
                              };
                              // +923139795674
                              final register = Register(phoneNumber: fullnmber);
                              print(fullnmber.length);
                              if (fullnmber.length == 13) {
                                var res = await http
                                    .post(url,
                                        headers: headers,
                                        body: json.encode(register.body()))
                                    .catchError((error) {
                                  alert.showFlushbar(
                                      "Server down", context, colors.red);
                                });
                                var decoded = json.decode(res.body);
                                if (decoded["status"] == 1) {
                                  navigate.push(
                                      context,
                                      PinVerification(
                                        number: "$fullnmber",
                                      ));
                                } else {
                                  print("number already exists");
                                  alert.showFlushbar("Number Already Exist",
                                      context, colors.red);
                                }
                              } else {
                                print("please add a valid nmber");
                                alert.showToast(context,
                                    "please Enter a Valid Number", Toast.TOP);
                              }
                            } else {
                              setState(() {
                                _autovalidate = true;
                              });
                            }
                          }
                        : null,
                    child: simple.text("Send Code",
                        color: colors.blue, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      simple.text("Already have an account? "),
                      InkWell(
                        onTap: () => navigate.pushRemove(context, SignIn()),
                        child: simple.text("Sign In",
                            color: colors.blue, fontWeight: FontWeight.w900),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
