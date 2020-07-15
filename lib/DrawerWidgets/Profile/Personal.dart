import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/commanWidget/pickerContainer.dart' as pC;

class Personal extends StatefulWidget {
  Personal({Key key}) : super(key: key);

  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  String name = "";
  Color male = colors.green;
  Color female = Colors.transparent;
  Color none = Colors.transparent;
  Color maleText = colors.white;
  Color femaleText = colors.black;
  Color noneText = colors.black;
  final picker = ImagePicker();
  String profilePic;
  File file;
  DateTime dateToday = DateTime.now();
  String pickedDate = "Pick Date";
  GoogleMapController mapController;
  StateSetter _stateSetter;
  double latitude = 37.43296265331129;
  double longitude = -122.08832357078792;
  String city, province, country, fullAddress;
  List<Marker> _markers = <Marker>[];
  @override
  void initState() {
    if (globals.gender == 0) {
      male = colors.green;
      female = Colors.transparent;
      none = Colors.transparent;
      maleText = colors.white;
      femaleText = colors.black;
      noneText = colors.black;
    } else if (globals.gender == 1) {
      male = Colors.transparent;
      female = colors.green;
      none = Colors.transparent;
      maleText = colors.black;
      femaleText = colors.white;
      noneText = colors.black;
    } else if (globals.gender == 2) {
      male = Colors.transparent;
      female = Colors.transparent;
      none = colors.green;
      maleText = colors.black;
      femaleText = colors.black;
      noneText = colors.white;
    }
    // String dob = "1996-07-02T00:00:00.000Z";
    // List<String> dobsplit = dob.split("T");
    // List<String> dobdashes = dobsplit[0].split("-");
    // int year = int.parse(dobdashes[0]);
    // int month = int.parse(dobdashes[1]);
    // int day = int.parse(dobdashes[2]);
    // var date = DateFormat.yMMMMEEEEd().format(DateTime(year, month, day));
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
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: InkWell(
                onTap: () => showChoiceDialogue(context),
                child: Container(
                  height: 120,
                  width: 120,
                  foregroundDecoration: BoxDecoration(
                      border: Border.all(color: colors.green, width: 3),
                      borderRadius: BorderRadius.circular(60),
                      image: DecorationImage(
                          image: file == null
                              ? NetworkImage("${globals.profilePic}")
                              : FileImage(file),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            space(),
            // Text(
            //   "$name",
            //   style: TextStyle(fontSize: 20),
            // ),
            simple.text("${globals.fullName}", fontSize: 20),
            divider(color: colors.blue),
            textField(globals.fullName, "name", false),
            textField("${globals.userName}", "username", false),
            textField("faisalkhan@gmail.com", "email", false),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: colors.lightGrey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        setState(() {
                          male = colors.green;
                          female = Colors.transparent;
                          none = Colors.transparent;
                          maleText = colors.white;
                          femaleText = colors.black;
                          noneText = colors.black;
                        });
                      },
                      child: gender("Male", 25, 0, male, maleText)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          male = Colors.transparent;
                          female = colors.green;
                          none = Colors.transparent;
                          maleText = colors.black;
                          femaleText = colors.white;
                          noneText = colors.black;
                        });
                      },
                      child: gender("Female", 0, 0, female, femaleText)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          male = Colors.transparent;
                          female = Colors.transparent;
                          none = colors.green;
                          maleText = colors.black;
                          femaleText = colors.black;
                          noneText = colors.white;
                        });
                      },
                      child: gender("Not Specified", 0, 25, none, noneText))
                ],
              ),
            ),
            InkWell(
                onTap: () async {
                  DateTime date = await showDatePicker(
                    context: context,
                    initialDate: dateToday,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050),
                  );
                  if (date != null && date != dateToday) {
                    String formatedDate =
                        DateFormat('EEEE, d MMM, yyyy').format(date);
                    setState(() {
                      pickedDate = formatedDate;
                    });
                  }
                },
                child: container(globals.dob)), //pickedDate)),
            divider(),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter stateSetter) {
                          _stateSetter = stateSetter;

                          return Container(
                            height: 500,
                            width: 320,
                            child: Stack(
                              children: <Widget>[
                                GoogleMap(
                                  markers: Set<Marker>.of(_markers),
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(latitude, longitude),
                                      zoom: 10),
                                  onMapCreated: (controller) {
                                    _stateSetter(() {
                                      mapController = controller;
                                      _markers.add(Marker(
                                        markerId: MarkerId('markerId'),
                                        position: LatLng(latitude, longitude),
                                      ));
                                    });
                                  },
                                  onCameraMove: (position) {
                                    _stateSetter(() {
                                      _markers.removeRange(
                                          0, _markers.length - 1);
                                      _markers.add(Marker(
                                        markerId: MarkerId('markerId'),
                                        position: LatLng(
                                            position.target.latitude,
                                            position.target.longitude),
                                      ));
                                      this.latitude = position.target.latitude;
                                      this.longitude =
                                          position.target.longitude;
                                    });
                                  },
                                ),
                                Positioned(
                                    top: 10,
                                    left: 20,
                                    right: 20,
                                    child: Container(
                                      width: 260,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Container(
                                          width: 260,
                                          height: 40,
                                          child: PlacesAutocompleteField(
                                            apiKey:
                                                "AIzaSyC1oVk1Wq9vi4morwisGT_fRuLXuYWTLsE",
                                            onChanged: (address) {
                                              Geolocator()
                                                  .placemarkFromAddress(address)
                                                  .then((value) {
                                                mapController.animateCamera(
                                                    CameraUpdate.newCameraPosition(
                                                        CameraPosition(
                                                            target: LatLng(
                                                                value[0]
                                                                    .position
                                                                    .latitude,
                                                                value[0]
                                                                    .position
                                                                    .longitude),
                                                            zoom: 10)));
                                                _stateSetter(() {
                                                  _markers.removeRange(
                                                      0, _markers.length - 1);
                                                  _markers.add(Marker(
                                                    markerId:
                                                        MarkerId('markerId'),
                                                    position: LatLng(
                                                      value[0]
                                                          .position
                                                          .latitude,
                                                      value[0]
                                                          .position
                                                          .longitude,
                                                    ),
                                                  ));
                                                  this.latitude = value[0]
                                                      .position
                                                      .latitude;
                                                  this.longitude = value[0]
                                                      .position
                                                      .longitude;
                                                });
                                              });
                                            },
                                          )),
                                    )),
                                Positioned(
                                  top: 450,
                                  left: 70,
                                  right: 70,
                                  child: InkWell(
                                    onTap: () async {
                                      final coordinates = new Coordinates(
                                          this.latitude, this.longitude);
                                      var addressess = await Geocoder.local
                                          .findAddressesFromCoordinates(
                                              coordinates);
                                      var first = addressess.first;
                                      setState(() {
                                        fullAddress = first.addressLine;
                                        city = first.subAdminArea;
                                        province = first.adminArea;
                                        country = first.countryName;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 130,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "Set Address",
                                        style: TextStyle(
                                            color: colors.white,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.2),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        })));
              },
              child: container("${fullAddress ?? globals.address}"),
            ),
            divider(),
            container("${city ?? globals.city}"),
            divider(),
            container("${province ?? globals.province}"),
            divider(),
            container("${country ?? globals.country}"),
            divider(),
            textField("${globals.cnic}", "nic", false,
                keyboardType: TextInputType.number, limit: 13),
            textField("${globals.passport ?? ""}", "passport", true,
                keyboardType: TextInputType.number)
          ],
        )),
      ),
    );
  }

  divider({color}) => Divider(
        color: color ?? colors.lightGrey,
        indent: 20,
        endIndent: 20,
      );
  space() => SizedBox(
        height: 20,
      );
  textField(String fieldValue, String fieldType, bool enabled,
          {TextInputType keyboardType, int limit}) =>
      Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Builder(builder: (context) {
            return TextFormField(
              initialValue: fieldValue,
              keyboardType: keyboardType,
              maxLength: limit,
              // controller: TextEditingController(text: value),
              decoration: InputDecoration(
                  counterText: "",
                  hintText: fieldType == "name"
                      ? "Enter Name"
                      : fieldType == "nic"
                          ? "Enter CNIC without Dashes"
                          : "Passport"),
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  fieldType == "name" ? name = value : print("object");
                });
              },
            );
          }));
  gender(String gender, double left, double right, Color color,
          Color textColor) =>
      Container(
        height: 50,
        width: 106,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(left),
                bottomLeft: Radius.circular(left),
                topRight: Radius.circular(right),
                bottomRight: Radius.circular(right))),
        child: Text("$gender",
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
      );
  container(value) => Container(
        height: 30,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5, left: 20),
        child: Text(
          "$value",
          overflow: TextOverflow.ellipsis,
        ),
      );
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
    setState(() {
      file = croppedImage;
    });
    profilePic = croppedImage.path;
    Uri uri = croppedImage.uri;
    print(uri);
  }
}
