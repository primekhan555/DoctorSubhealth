import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subhealth_doctorapp/APIsModels/GetUserData.dart';
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/Profile.dart';
import 'package:subhealth_doctorapp/Enterance/SignIn.dart';
import 'package:subhealth_doctorapp/MainSection/MainScreen.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = "${globals.baseUrl}api/app/auth/user";
    Map<String, String> headers = {"Content-type": "application/json"};
    bool exist = prefs.containsKey("userId");
    if (exist) {
      String userId = prefs.getString("userId");
      final getUserData = GetUserData(userId: userId);
      var res = await http
          .post(url, headers: headers, body: json.encode(getUserData.body()))
          .catchError((error) =>
              alert.showFlushbar("Server Down", context, colors.red));
      if (res.statusCode == 200) {
        var decoded = json.decode(res.body);
        var user = decoded["userdetail"];
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
        String dobString = user["dob"];
        List<String> dobsplit = dobString.split("T");
        List<String> dobdashes = dobsplit[0].split("-");
        int year = int.parse(dobdashes[0]);
        int month = int.parse(dobdashes[1]);
        int day = int.parse(dobdashes[2]);
        String date =
            DateFormat.yMMMMEEEEd().format(DateTime(year, month, day));
        globals.dob = date;
        if (globals.acountStatus == 0 || globals.acountStatus == 1) {
          navigate.pushRemove(context, Profile());
        } else if (globals.acountStatus == 2) {
          navigate.pushRemove(context, MainScreen());
        }
      }
    } else
      navigate.pushRemove(context, SignIn());
  }

  @override
  void initState() {
    log("message");
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Center(
        child: assets.logoCont(),
      ),
    );
  }
}
