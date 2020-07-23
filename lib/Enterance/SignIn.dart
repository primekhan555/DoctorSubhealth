import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:subhealth_doctorapp/APIsModels/Login.dart';
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/Profile.dart';
import 'package:subhealth_doctorapp/Enterance/ForgotPassword.dart';
import 'package:subhealth_doctorapp/Enterance/Registeration.dart';
import 'package:subhealth_doctorapp/MainSection/MainScreen.dart';
import 'package:subhealth_doctorapp/MainSection/Patient/PatientHome.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;
import 'package:shared_preferences/shared_preferences.dart';

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
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/loginback.png"),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
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
                        textField("Password", TextInputType.text, true,
                            "password", 30),
                        InkWell(
                          onTap: () => navigate.push(context, Forgotpassword()),
                          child: simple.container(
                              simple.text("Forgot password ?",
                                  color: colors.blue, fontSize: 14),
                              20,
                              width,
                              margin: 20,
                              alignment: Alignment.centerRight),
                        ),
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
                                  var res = await http
                                      .post(url,
                                          headers: headers,
                                          body: json.encode(login.body()))
                                      .catchError((error) => alert.showFlushbar(
                                          "Server Down", context, colors.red));
                                  log("${res.statusCode}");
                                  var decoded = json.decode(res.body);
                                  if (res.statusCode == 201) {
                                    var user = decoded["user"]["profile"];
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString("token", user["token"]);
                                    prefs.setString("userId", user["_id"]);
                                    log("${user["token"]}");
                                    globals.acountStatus = user["acountStatus"];
                                    globals.profilePic = user["profilePic"];
                                    globals.fullName = user["userFullName"];
                                    globals.userName = user["username"];
                                    globals.number = user["mobile"];
                                    globals.cnic = user["cnic"];
                                    globals.address = user["address"];
                                    globals.country = user["country"];
                                    globals.province = user["province"];
                                    globals.city = user["city"];
                                    globals.passport = user["passportNo"];
                                    globals.gender = user["gender"];
                                    globals.specialityName =
                                        user["specialityId"];
                                    String dobString = user["dob"];
                                    bool check =
                                        globals.profilePic.contains("https");
                                    if (!check)
                                      globals.profilePic =
                                          globals.baseUrl + globals.profilePic;
                                    else
                                      globals.profilePic = globals.profilePic;
                                    List<String> dobsplit =
                                        dobString.split("T");
                                    List<String> dobdashes =
                                        dobsplit[0].split("-");
                                    int year = int.parse(dobdashes[0]);
                                    int month = int.parse(dobdashes[1]);
                                    int day = int.parse(dobdashes[2]);
                                    String date = DateFormat.yMMMMEEEEd()
                                        .format(DateTime(year, month, day));
                                    globals.dob = date;

                                    if (user["role"] == 1) {
                                      //doctor
                                      var doctorInfo = decoded["user"]["info"];
                                      globals.consultant =
                                          doctorInfo["description"];
                                      globals.registerationNo =
                                          doctorInfo["medicalRegistrationNo"];
                                      if (doctorInfo["specialityId"] != null) {
                                        globals.specialityName =
                                            doctorInfo["specialityId"]["name"];
                                      }
                                      log("${globals.id}");
                                      globals.userId = user["doctorId"];
                                      navigate.pushRemove(
                                          context, MainScreen());
                                      if (globals.acountStatus == 0 ||
                                          globals.acountStatus == 1) {
                                        navigate.pushRemove(context, Profile());
                                      } else if (globals.acountStatus == 2) {
                                        // user["doctorId"]
                                        navigate.pushRemove(
                                            context, MainScreen());
                                      }
                                    } else if (user["role"] == 2) {
                                      //go to patient
                                      globals.userId = user["patientId"];
                                      navigate.pushRemove(
                                          context, PatientHome());
                                    }
                                  } else
                                    alert.showFlushbar("${decoded["message"]}",
                                        context, colors.red);
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
