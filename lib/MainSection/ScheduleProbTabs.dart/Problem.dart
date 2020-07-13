import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;

class Problem extends StatefulWidget {
  Problem({Key key}) : super(key: key);

  @override
  _ProblemState createState() => _ProblemState();
}

class _ProblemState extends State<Problem> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool isPlaying = false;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Container(
                height: 70,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text("subhealth"),
                    ),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              simple.text("Faisal Khalid", fontSize: 12),
                              simple.text("MBBS", fontSize: 12),
                              simple.text("consultant", fontSize: 12),
                            ],
                          ),
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: colors.lightGrey,
                              border:
                                  Border.all(color: colors.green, width: 3)),
                          child: Icon(Icons.person),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        simple.text("Subhealth (Private)", fontSize: 11),
                        simple.text("Limited", fontSize: 11),
                        simple.text("Thu Jul 09 2020", fontSize: 11),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        simple.text("PMDC REG # 234567", fontSize: 11),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  height: 270,
                  width: width,
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: simple.text("Problem",
                              fontSize: 17, fontWeight: FontWeight.w900)),
                      Container(
                        width: width,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.grey)),
                        child: simple.text("afsfffffffffffffffffffsafs"),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            simple.text("00 : 10"),
                            IconButton(
                              icon: AnimatedIcon(
                                  color: colors.blue,
                                  icon: AnimatedIcons.play_pause,
                                  progress: _animationController),
                              onPressed: _handleOnPressed,
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 130,
                          height: 45,
                          child: RaisedButton(
                              color: colors.blue,
                              onPressed: () {},
                              child: simple.text("Appointment",
                                  color: colors.white, fontSize: 15)),
                        ),
                      )
                    ],
                  )),
              Container(
                height: 300,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: simple.text("Prescription",
                          fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          simple.container(textField("Medicine"), 40, 150,
                              borderColor: colors.lightGrey, radius: 5),
                          simple.container(textField("Dosage"), 40, 70,
                              borderColor: colors.lightGrey, radius: 5),
                          simple.container(textField("Frequency"), 40, 70,
                              borderColor: colors.lightGrey, radius: 5)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          simple.container(
                              textField("Medicine", maxLines: 5), 80, 230,
                              borderColor: colors.lightGrey, radius: 5),
                          simple.container(
                              textField("Dosage", maxLines: 5), 80, 70,
                              borderColor: colors.lightGrey, radius: 5),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 130,
                        height: 45,
                        child: RaisedButton.icon(
                          textColor: colors.white,
                          color: colors.blue,
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: simple.text("Add", color: colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 130,
                        height: 45,
                        child: RaisedButton(
                          textColor: colors.white,
                          color: colors.blue,
                          onPressed: () {},
                          child: simple.text("Verify", color: colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  textField(String hint, {int maxLines}) {
    return TextField(
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(hintText: "$hint", border: InputBorder.none),
    );
  }
}
