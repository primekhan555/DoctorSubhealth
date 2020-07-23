import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subhealth_doctorapp/APIsModels/UpdateDoctorProfile.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/About.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/Personal.dart';
import 'package:subhealth_doctorapp/Enterance/SignIn.dart';
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
            centerTitle: true,
            leading: globals.acountStatus == 0 || globals.acountStatus == 1
                ? IconButton(
                    icon: simple.icon(FontAwesomeIcons.signOutAlt,
                        color: colors.white),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove("userId");
                      navigate.pushRemove(context, SignIn());
                    },
                  )
                : IconButton(
                    icon: simple.icon(Icons.arrow_back, color: colors.white),
                    onPressed: () => Navigator.pop(context)),
            actions: <Widget>[
              InkWell(
                onTap: () async {
                  log("${globals.secondPageChange}");
                  if (globals.changes == true) {
                    // globals.changes = false;
                    String url =
                        "${globals.baseUrl}api/app/auth/updatedoctorprofile";
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String userId = prefs.getString("userId");
                    // MultipartFile file =
                    //     await MultipartFile.fromFile("fff", filename: "asf");

                    final docData = UpdateDoctorProfile(
                        userId: userId,
                        fullname: globals.fullName,
                        gender: globals.gender.toString(),
                        passportNo: globals.passport,
                        address: globals.address,
                        city: globals.city,
                        country: globals.country,
                        province: globals.province,
                        cnic: globals.cnic,
                        dob: globals.dob,
                        latitude: globals.latitude,
                        longitude: globals.longitude,
                        email: globals.emailUpdating,
                        medicalRegistrationNo: globals.registerationNo,
                        specilityId: globals.speciality,
                        description: globals.consultant,
                        doctorinfo: globals.secondPageChange,
                        speciality: globals.specialMapList.toString(),
                        qualification: globals.qualMapList.toString(),
                        certificates: globals.certificateMapList.toString(),
                        hospitalAddress: globals.hospitalAddress,
                        hospitalContact: globals.hospitalNumber,
                        profilePic: globals.image,
                        resume: globals.cv,
                        signature: globals.signature);

                    Map<String, String> headers = {
                      "Content-type": "multipart/form-data"
                    };
                    Dio dio = Dio();
                    try {
                      FormData formData = new FormData.fromMap(docData.body());
                      Response res = await dio.post(url,
                          data: formData, options: Options(headers: headers));
                      log("${res.statusCode}");
                      log("${res.data.toString()}");
                      if (res.statusCode == 200) {
                        alert.showFlushbar(
                            res.data["message"], context, colors.green,
                            duration: 2000);
                        globals.changes = false;
                        Timer(Duration(milliseconds: 2000),
                            () => navigate.pushRemove(context, Profile()));
                      } else {
                        alert.showFlushbar(
                            res.data["message"], context, colors.red,
                            duration: 2000);
                        showDialog(
                          context: context,
                        );
                      }
                    } catch (e) {
                      log("+++++++++++++++++++++++++++++++");
                    }
                    // var res = await http.post(url,
                    //     headers: headers, body: json.encode(docData.body()));
                    // log("${res.statusCode}");
                    // if (res.statusCode == 200) {
                    //   var decoded = json.decode(res.body);
                    //   log("$decoded");
                    //   alert.showFlushbar(
                    //       decoded["message"], context, colors.green,
                    //       duration: 2000);
                    //   globals.textChanges = false;
                    //   Timer(Duration(milliseconds: 2000),
                    //       () => navigate.pushRemove(context, Profile()));
                    // } else {
                    //   var decoded = json.decode(res.body);
                    //   alert.showFlushbar(
                    //       "${decoded["message"]}", context, colors.red,
                    //       duration: 2000);
                    //   // showDialog(
                    //   //   context: context,
                    //   // );
                    // }
                  } else {
                    alert.showFlushbar(
                        "Please make some change first", context, colors.grey,
                        duration: 2000);
                  }

                  // log("/")
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.save),
                      simple.text("Save", color: colors.white),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
              )
            ],
            bottom: TabBar(tabs: [Tab(text: "Personal"), Tab(text: "About")]),
          ),
          body: TabBarView(children: [Personal(), About()]),
        ));
  }
}
