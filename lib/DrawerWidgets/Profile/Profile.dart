import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/About.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/Personal.dart';
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool textChanges = false;
  bool fileChanges = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
            centerTitle: true,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  print("object");
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
