import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subhealth_doctorapp/Enterance/ForgotPassword.dart';
import 'package:subhealth_doctorapp/Enterance/SignIn.dart';
import 'package:subhealth_doctorapp/Enterance/Splash.dart';
import 'package:subhealth_doctorapp/MainSection/MainScreen.dart';
import 'Resources/colors.dart' as colors;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: colors.blue));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'SubHealth Doctor',
      theme: ThemeData(
        fontFamily: "SFProDisplay",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}
