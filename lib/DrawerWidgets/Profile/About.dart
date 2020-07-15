import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subhealth_doctorapp/commanWidget/pickerContainer.dart' as pC;
import 'package:image_cropper/image_cropper.dart';
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

List<String> checked = [];

class _AboutState extends State<About> {
  final picker = ImagePicker();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String dropDownValue = "Select";
  List<String> dropList = ["afsf", "34t34", "456456", "44444"];
  List<String> specialTitleL = [];
  List<String> specialDescL = [];
  List<String> qualTitleL = [];
  List<String> qualDescL = [];
  List<String> certTitleL = [];
  List<String> certDescL = [];
  List list = List();
  String specialName = "Select Specialization";
  String specialValue;
  // List<String> daysL = [
  //   "Monday",
  //   "Tuesday",
  //   "Wednesday",
  //   "Thursday",
  //   "Friday",
  //   "Saturday",
  //   "Sunday"
  // ];
  // Map<String, bool> map = {
  //   "Monday": false,
  //   "Tuesday": false,
  // };
  List<String> interchecked = [];

  getSpecialities() async {
    String url = "${globals.baseUrl}api/website/getspecality";
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var decoded = json.decode(res.body);
      setState(() {
        list = decoded["speciality"];
      });
    }
  }

  @override
  void initState() {
    getSpecialities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            globals.acountStatus == 0
                ? simple.container(
                    simple.text("Please Update your Profile",
                        color: colors.white),
                    35,
                    width,
                    color: colors.red)
                : Container(),
            globals.acountStatus == 1
                ? simple.container(
                    simple.text("Your Account is Pending", color: colors.white),
                    35,
                    width,
                    color: colors.red)
                : Container(),
            Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Column(
                children: <Widget>[
                  textField(),
                  textField(enabled: false, fieldValue: "faisal"),
                  Container(
                    width: width,
                    height: 50,
                    child: DropdownButton(
                      isExpanded: true,
                      items: list.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: item['_id'].toString(),
                          onTap: () {
                            setState(() {
                              specialValue = item["_id"];
                              specialName = item["name"];
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (value) {},
                      hint: simple.text(
                        "$specialName",
                      ),
                      // hint: Text(
                      //   "$specialName",
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // value: "$_mySelection",
                    ),
                  ),
                  attachmentRow("Add CV", "file"),
                  attachmentRow("Add Signature", "jpg"),
                  addingQualEtc("Special-interest", "special"),
                  listQualEtc(specialTitleL, specialDescL, "special"),
                  addingQualEtc("Qualification", "qual"),
                  listQualEtc(qualTitleL, qualDescL, "qual"),
                  addingQualEtc("Certificate", "cert"),
                  listQualEtc(certTitleL, certDescL, "cert"),
                  // InkWell(
                  //   onTap: () => bottomSheet(),
                  //   child: simple.container(Text("  $map"), 35, width,
                  //       radius: 5,
                  //       alignment: Alignment.centerLeft,
                  //       borderColor: colors.lightGrey,
                  //       margin: 10),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
      // ),
    ));
  }

  textField({bool enabled, String fieldValue}) => Container(
        child: TextFormField(
          initialValue: fieldValue,
          enabled: enabled,
        ),
      );
  attachmentRow(String name, String type) => Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "$name",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            Container(
              decoration:
                  BoxDecoration(color: colors.green, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: () async {
                  getDFile(type);
                },
                color: colors.white,
              ),
            )
          ],
        ),
      );
  getDFile(String type) async {
    if (type == "file") {
      File file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ["pdf", "doc"]);
      Uri uri = file.uri;
      print(uri.toString());
    } else {
      showChoiceDialogue(context);
    }
  }

  Future showChoiceDialogue(BuildContext context) async => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          backgroundColor: colors.white,
          content: Container(
              height: 140,
              child: Column(children: <Widget>[
                pC.pickerContainer("Select Any", colors.white, colors.blue, 30,
                    FontWeight.w900, 0),
                InkWell(
                    onTap: () {
                      pickImage(context, "camera");
                      Navigator.of(context).pop();
                    },
                    child: pC.pickerContainer("Camera", Colors.black,
                        Colors.grey[200], 50, FontWeight.normal, 5)),
                InkWell(
                    onTap: () {
                      pickImage(context, "gallery");
                      Navigator.of(context).pop();
                    },
                    child: pC.pickerContainer("Gallery", Colors.black,
                        Colors.grey[200], 50, FontWeight.normal, 5)),
              ]))));

  pickImage(BuildContext context, String source) async {
    final picture = await picker.getImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery);
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: picture.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    Uri uri = croppedImage.uri;
    print(uri);
  }

  addingQualEtc(String name, String type) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$name"),
          InkWell(
              onTap: () {
                if (type == "special") {
                  addingDialog(type);
                } else if (type == "qual") {
                  addingDialog(type);
                } else {
                  print("certificate");
                  addingDialog(type);
                }
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(right: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colors.red, shape: BoxShape.circle),
                        child: Icon(
                          Icons.add,
                          size: 15,
                          color: colors.white,
                        )),
                    Text(
                      "Add",
                      style: TextStyle(
                          color: colors.red,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.red),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  listQualEtc(List<String> title, List<String> desc, String type) {
    return Container(
        child: ListView.builder(
      itemCount: title.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    simple.icon(Icons.star, color: colors.blue),
                    simple.text("${title[index]}", color: colors.blue)
                  ],
                ),
              ),
              IconButton(
                icon: simple.icon(Icons.close, color: colors.blue),
                onPressed: () {
                  setState(() {
                    if (type == "special") {
                      title.removeAt(index);
                      desc.removeAt(index);
                    } else if (type == "qual") {
                      title.removeAt(index);
                      desc.removeAt(index);
                    } else {
                      title.removeAt(index);
                      desc.removeAt(index);
                    }
                  });
                },
              )
            ],
          ),
        );
      },
    ));
  }

  addingDialog(String type) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            alignment: Alignment.center,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: simple.icon(Icons.close, color: colors.red),
                      onPressed: () {
                        _titleController.clear();
                        _descController.clear();
                        Navigator.pop(context);
                      }),
                ),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          hintText: type == "special"
                              ? "Special-interest Title"
                              : type == "qual"
                                  ? "Qualification Title"
                                  : "Certificate"),
                    )),
                Container(
                    height: 100,
                    width: 220,
                    decoration: BoxDecoration(
                        border: Border.all(color: colors.lightGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          contentPadding: EdgeInsets.all(10)),
                      maxLines: 7,
                    )),
                InkWell(
                  onTap: () {
                    if (_titleController.text.isEmpty &&
                        _descController.text.isEmpty) {}
                    setState(() {
                      if (type == "special") {
                        specialTitleL.add(_titleController.text);
                        specialDescL.add(_descController.text);
                      } else if (type == "qual") {
                        qualTitleL.add(_titleController.text);
                        qualDescL.add(_descController.text);
                      } else {
                        certTitleL.add(_titleController.text);
                        certDescL.add(_descController.text);
                      }
                      _titleController.clear();
                      _descController.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: simple.container(
                        simple.text("Done", color: colors.white), 50, 150,
                        color: colors.green, radius: 10),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
//   bottomSheet() => showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//           height: 500,
//           child: Column(
//             children: <Widget>[
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: map.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Row(
//                     children: <Widget>[
//                       Checkbox(
//                         value: map.values.elementAt(index),
//                         onChanged: (value) {
//                           print(map.values.elementAt(index));
//                           // setState(() {
//                           // toggle = !value;

//                           map.update(map.keys.elementAt(index), (keyvalue) {
//                             setState(() {
//                               keyvalue = value;
//                             });
//                             return keyvalue;
//                           });
//                           // });
//                         },
//                       ),
//                       GestureDetector(
//                           onTap: () {
//                             print("fffff");
//                           },
//                           child: CheckBoxD()),
//                       simple.text(map.keys.elementAt(index),
//                           color: colors.blue,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w900)
//                     ],
//                   );
//                 },
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   MaterialButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: simple.text("Cancel", color: colors.red),
//                   ),
//                   MaterialButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: simple.text("Continue",
//                         color: colors.green, fontSize: 18),
//                   ),
//                 ],
//               )
//             ],
//           )));
// }

// class CheckBoxD extends StatefulWidget {
//   final String item;
//   CheckBoxD({Key key, this.item}) : super(key: key);

//   @override
//   _CheckBoxDState createState() => _CheckBoxDState();
// }

// class _CheckBoxDState extends State<CheckBoxD> {
//   bool toggle = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Checkbox(
//         value: toggle,
//         onChanged: (value) {
//           setState(() {
//             toggle = value;
//             if (value) {
//               checked.add(widget.item);
//             } else {
//               checked.remove(widget.item);
//             }
//           });
//         },
//       ),
//     );
//   }
// }
