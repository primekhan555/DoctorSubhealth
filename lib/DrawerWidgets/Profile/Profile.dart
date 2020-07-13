import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/About.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/Personal.dart';

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
            bottom: TabBar(tabs: [Tab(text: "Personal"), Tab(text: "About")]),
          ),
          body: TabBarView(children: [Personal(), About()]),
        ));
  }
}
