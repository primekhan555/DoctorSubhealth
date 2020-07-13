import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Profile/Profile.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Settings.dart';
import 'package:subhealth_doctorapp/DrawerWidgets/Support.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<IconData> itemsIcons = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.userCircle,
    FontAwesomeIcons.cog,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.copy,
    FontAwesomeIcons.signOutAlt
  ];
  List<String> itemsStrings = [
    "Home",
    "Profile",
    "Settings",
    "Support",
    "Terms",
    "Logout"
  ];
  List<Widget> itemWidgets = [
    null,
    Profile(),
    Settings(),
    Support(),
    null,
    null
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                height: 120,
                width: 120,
                foregroundDecoration: BoxDecoration(
                    border: Border.all(color: colors.green, width: 3),
                    borderRadius: BorderRadius.circular(60),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://miro.medium.com/max/3072/1*o-UCEnQ3VRCrHjI8cx4JBQ.jpeg"),
                        fit: BoxFit.cover)),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Faisal Khalid",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                height: 370,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemsStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        if (index == 0) {
                          Navigator.pop(context);
                          return;
                        }
                        navigate.push(context, itemWidgets[index]);
                      },
                      leading: Icon(
                        itemsIcons[index],
                        color: index == 0 ? colors.blue : colors.grey,
                      ),
                      title: Text(
                        "${itemsStrings[index]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: index == 0 ? colors.blue : colors.grey),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
