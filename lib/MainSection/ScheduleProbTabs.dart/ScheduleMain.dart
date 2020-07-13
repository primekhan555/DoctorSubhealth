import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/MainSection/ScheduleProbTabs.dart/Problem.dart';
import 'package:subhealth_doctorapp/MainSection/ScheduleProbTabs.dart/Result.dart';
// import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;

class ScheduleMain extends StatefulWidget {
  final String name;
  ScheduleMain({Key key, this.name}) : super(key: key);

  @override
  _ScheduleMainState createState() => _ScheduleMainState();
}

class _ScheduleMainState extends State<ScheduleMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${widget.name}",
              style: TextStyle(color: colors.white),
            ),
            centerTitle: true,
            bottom: TabBar(tabs: [
              Tab(
                text: "Problem",
              ),
              Tab(
                text: "Result",
              )
            ]),
          ),
          body: TabBarView(children: [Problem(), Result()]),
        ));
  }
}
