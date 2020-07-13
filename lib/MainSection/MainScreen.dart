import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/MainSection/HistoryTab.dart';
import 'package:subhealth_doctorapp/MainSection/MainDrawer.dart';
import 'package:subhealth_doctorapp/MainSection/ScheduleTab.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Home",
                ),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    onPressed: () {
                      setState(() {
                        show = !show;
                      });
                    },
                  )
                ],
                bottom: TabBar(tabs: [
                  Tab(
                    text: "Schedule",
                  ),
                  Tab(
                    text: "History",
                  )
                ]),
              ),
              drawer: Drawer(
                child: MainDrawer(),
              ),
              body: TabBarView(children: [ScheduleTab(), HistoryTab()]),
            )),
        show
            ? Container(
                // padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(top: 90, right: 10),
                padding: EdgeInsets.only(top: 0),
                height: 130,
                width: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        popupItems("assets/images/noti1.png"),
                        popupItems("assets/images/noti2.png")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        popupItems("assets/images/noti3.png"),
                        popupItems("assets/images/noti4.png")
                      ],
                    )
                  ],
                ))
            : Container(),
      ],
    );
  }

  popupItems(String url) => Container(
        height: 60,
        width: 60,
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage(url))),
      );
}
