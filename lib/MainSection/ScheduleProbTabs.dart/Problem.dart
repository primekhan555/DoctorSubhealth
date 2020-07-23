import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;

class Problem extends StatefulWidget {
  Problem({Key key}) : super(key: key);

  @override
  _ProblemState createState() => _ProblemState();
}

class _ProblemState extends State<Problem> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final _mediController = TextEditingController();
  final _dosageController = TextEditingController();
  final _freqController = TextEditingController();
  final _desController = TextEditingController();
  final _des2Controller = TextEditingController();
  FocusNode mediFocus = new FocusNode();
  bool isPlaying = false;
  List<int> presc = [1];
  String medicines, dosage, freq, instruction, duration;
  List prescrip = [];
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mediController.dispose();
    _dosageController.dispose();
    _freqController.dispose();
    _desController.dispose();
    _des2Controller.dispose();
    mediFocus.dispose();
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
    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                          padding: EdgeInsets.all(7),
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
                  // height: 300,
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
                        child: ListView.builder(
                          itemCount: prescrip.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  simple.text("${index + 1}"),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        simple.container(
                                            simple.text(
                                                prescrip[index]["medicines"]),
                                            40,
                                            150,
                                            borderColor: colors.lightGrey,
                                            radius: 5),
                                        simple.container(
                                            simple.text(
                                                prescrip[index]["dosage"]),
                                            40,
                                            70,
                                            borderColor: colors.lightGrey,
                                            radius: 5),
                                        simple.container(
                                            simple
                                                .text(prescrip[index]["freq"]),
                                            40,
                                            70,
                                            borderColor: colors.lightGrey,
                                            radius: 5)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        simple.container(
                                            simple
                                                .text(prescrip[index]["descr"]),
                                            80,
                                            230,
                                            borderColor: colors.lightGrey,
                                            radius: 5),
                                        simple.container(
                                            simple.text(
                                                prescrip[index]["descr2"]),
                                            80,
                                            70,
                                            borderColor: colors.lightGrey,
                                            radius: 5),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: simple.container(
                                        OutlineButton(
                                          borderSide:
                                              BorderSide(color: colors.red),
                                          onPressed: () {
                                            setState(() {
                                              prescrip.removeAt(index);
                                            });
                                          },
                                          child: simple.text("Remove",
                                              color: colors.red),
                                        ),
                                        30,
                                        100,
                                        margin: 10,
                                        alignment: Alignment.centerRight),
                                  )
                                  // : Container(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      prescription(),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 130,
                          height: 45,
                          child: RaisedButton.icon(
                            textColor: colors.white,
                            color: colors.blue,
                            onPressed: () {
                              if (medicines == null || medicines.isEmpty) {
                                return alert.showFlushbar(
                                    "Please fill the Medicines Field",
                                    context,
                                    colors.red);
                              } else if (dosage == null || dosage.isEmpty) {
                                return alert.showFlushbar(
                                    "Please fill the Dosage Field",
                                    context,
                                    colors.red);
                              } else if (freq == null || freq.isEmpty) {
                                return alert.showFlushbar(
                                    "Please fill the Frequency Field",
                                    context,
                                    colors.red);
                              } else if (instruction == null ||
                                  instruction.isEmpty) {
                                return alert.showFlushbar(
                                    "Please fill the Description Field",
                                    context,
                                    colors.red);
                              } else if (duration == null || duration.isEmpty) {
                                return alert.showFlushbar(
                                    "Please fill the Description2 Field",
                                    context,
                                    colors.red);
                              }
                              Map<String, String> map = {
                                "medicines": medicines,
                                "dosage": dosage,
                                "freq": freq,
                                "descr": instruction,
                                "descr2": duration
                              };
                              setState(() {
                                prescrip.add(map);
                                _mediController.clear();
                                _dosageController.clear();
                                _des2Controller.clear();
                                _desController.clear();
                                _freqController.clear();
                                FocusScope.of(context).requestFocus(mediFocus);
                              });

                              print(prescrip.toString());
                            },
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
      ),
    );
  }

  prescription() => Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  simple.container(
                      TextField(
                        controller: _mediController,
                        maxLines: 1,
                        focusNode: mediFocus,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (v) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            hintText: "Medicines", border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            medicines = value;
                          });
                        },
                      ),
                      40,
                      150,
                      borderColor: colors.lightGrey,
                      radius: 5),
                  simple.container(
                      TextField(
                        controller: _dosageController,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (v) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            hintText: "Dosage", border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            dosage = value;
                          });
                        },
                      ),
                      40,
                      70,
                      borderColor: colors.lightGrey,
                      radius: 5),
                  simple.container(
                      TextField(
                        controller: _freqController,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (v) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            hintText: "Frequency", border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            freq = value;
                          });
                        },
                      ),
                      40,
                      70,
                      borderColor: colors.lightGrey,
                      radius: 5)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  simple.container(
                      TextField(
                        controller: _desController,
                        maxLines: 5,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (v) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            hintText: "Instruction", border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            instruction = value;
                          });
                        },
                      ),
                      80,
                      230,
                      borderColor: colors.lightGrey,
                      radius: 5),
                  simple.container(
                      TextField(
                        controller: _des2Controller,
                        maxLines: 5,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (v) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                            hintText: "Duration", border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            duration = value;
                          });
                        },
                      ),
                      80,
                      70,
                      borderColor: colors.lightGrey,
                      radius: 5),
                ],
              ),
            ),
          ],
        ),
      );
}
