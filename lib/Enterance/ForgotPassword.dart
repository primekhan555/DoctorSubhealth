import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subhealth_doctorapp/APIsModels/Register.dart';
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/Enterance/PinVerification.dart';
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Forgotpassword extends StatefulWidget {
  Forgotpassword({Key key}) : super(key: key);

  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  String number = "1";
  bool enable = false;
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
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/loginback.png"),
                  fit: BoxFit.cover)),
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Column(
            children: <Widget>[
              assets.logoCont(marginBottom: 8),
              simple.container(
                  simple.text("Reset Password",
                      color: colors.mediumGrey, fontWeight: FontWeight.w900),
                  15,
                  width),
              Divider(
                indent: 83,
                endIndent: 83,
                color: colors.mediumGrey,
              ),
              simple.container(
                  simple.text("Please enter your phone number",
                      color: colors.mediumGrey, fontSize: 12),
                  17,
                  width),
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      hintText: "Enter number", counterText: ""),
                  onChanged: (value) {
                    log("dfasdf");
                    print("object");
                    setState(() {
                      number = value;
                      if (number.length == 10) {
                        enable = true;
                      } else
                        enable = false;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 30),
                width: width,
                height: 40,
                child: OutlineButton(
                  child: simple.text("NEXT", color: colors.blue),
                  borderSide: BorderSide(color: colors.blue, width: 1.5),
                  onPressed: enable
                      ? () async {
                          log("$number");
                          String fullNumber = "+92$number";
                          log("$fullNumber");
                          // String fullnmber = "+92$number";
                          // number = "1";
                          String url =
                              "${globals.baseUrl}api/app/auth/isNumber";
                          Map<String, String> headers = {
                            "Content-type": "application/json"
                          };
                          // +923139795674
                          final register = Register(phoneNumber: fullNumber);
                          print(fullNumber.length);
                          if (fullNumber.length == 13) {
                            var res = await http
                                .post(url,
                                    headers: headers,
                                    body: json.encode(register.body()))
                                .catchError((error) {
                              alert.showFlushbar(
                                  "Server down", context, colors.red);
                            });
                            var decoded = json.decode(res.body);
                            log("${decoded["status"]}");
                            if (decoded["status"] == 0) {
                              navigate.push(
                                  context,
                                  PinVerification(
                                    number: "$fullNumber",
                                    status: 0,
                                  ));
                            } else {
                              print("number already exists");
                              alert.showFlushbar(
                                  "Number does not Exist", context, colors.red);
                            }
                          } else {
                            print("please add a valid nmber");
                            alert.showToast(context,
                                "please Enter a Valid Number", Toast.TOP);
                          }
                        }
                      : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
