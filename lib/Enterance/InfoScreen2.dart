import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subhealth_doctorapp/APIsModels/RegisterationPost.dart';
import 'package:subhealth_doctorapp/Enterance/SignIn.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:intl/intl.dart';
import 'package:subhealth_doctorapp/Assets/assets.dart' as assets;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:http/http.dart' as http;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;
import 'dart:convert';
import 'package:subhealth_doctorapp/Warnings/warnings.dart' as alert;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;

class InfoScreen2 extends StatefulWidget {
  final String number, role, fullName, userName, cnic, password;
  InfoScreen2(
      {Key key,
      this.number,
      this.role,
      this.fullName,
      this.userName,
      this.cnic,
      this.password})
      : super(key: key);

  @override
  _InfoScreen2State createState() => _InfoScreen2State();
}

class _InfoScreen2State extends State<InfoScreen2> {
  Color male = colors.green;
  Color female = Colors.transparent;
  Color none = Colors.transparent;
  Color maleText = colors.white;
  Color femaleText = colors.black;
  Color noneText = colors.black;
  GoogleMapController mapController;
  DateTime dateToday = DateTime.now();
  String pickedDate = "Date of Birth";
  StateSetter _stateSetter;
  double latitude = 30.3753;
  double longitude = 69.3451;
  String city = "City",
      province = "Province",
      country = "Country",
      fullAddress = "location";
  String gendertype = "1";
  List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              assets.logoCont(),
              Container(
                height: 50,
                // width: 150,
                // margin: EdgeInsets.only(top: 40, right: 19, left: 19),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: colors.lightGrey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          setState(() {
                            gendertype = "0";
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
                            gendertype = "1";
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
                            gendertype = "2";
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
                  child: container(pickedDate)),
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

                                        this.latitude =
                                            position.target.latitude;
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
                                                    .placemarkFromAddress(
                                                        address)
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
                child: container("$fullAddress"),
              ),
              divider(),
              container("$city", color: colors.grey),
              divider(),
              container("$province", color: colors.grey),
              divider(),
              container("$country", color: colors.grey),
              divider(),
              Container(
                width: width,
                height: 50,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 1, right: 1, bottom: 1),
                child: OutlineButton(
                  borderSide: BorderSide(color: colors.blue, width: 2),
                  onPressed: () async {
                    String url = "${globals.baseUrl}api/app/auth/resgister";
                    Map<String, String> headers = {
                      "Content-type": "application/json"
                    };
                    String latitudeS = this.latitude.toString();
                    String longitudeS = this.longitude.toString();
                    final registeration = RegisterationPost(
                        role: widget.role,
                        username: widget.userName,
                        mobile: widget.number,
                        fullname: widget.fullName,
                        password: widget.password,
                        dob: this.pickedDate,
                        gender: this.gendertype,
                        address: this.fullAddress,
                        city: this.city,
                        province: this.province,
                        country: this.country,
                        cnic: widget.cnic,
                        latitude: latitudeS,
                        longitude: longitudeS);
                    var res = await http
                        .post(url,
                            headers: headers,
                            body: json.encode(registeration.body()))
                        .catchError((error) {
                      alert.showFlushbar("Server down", context, colors.red);
                    });
                    var decoded = json.decode(res.body);
                    if (res.statusCode == 201) {
                      alert.showFlushbar(
                          "${decoded["message"]}", context, colors.green);
                      Timer(Duration(milliseconds: 1500),
                          () => navigate.pushRemove(context, SignIn()));
                    } else if (res.statusCode == 404) {
                      alert.showFlushbar(
                          "${decoded["message"]}", context, colors.red);
                    }
                  },
                  child:
                      simple.text("Confirm", color: colors.blue, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  gender(String gender, double left, double right, Color color,
          Color textColor) =>
      Container(
          height: 50,
          width: 89.3,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(left),
                  bottomLeft: Radius.circular(left),
                  topRight: Radius.circular(right),
                  bottomRight: Radius.circular(right))),
          child: Text("$gender",
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12)));
  divider({color}) => Divider(color: color ?? colors.lightGrey);
  container(value, {Color color}) => Container(
      height: 30,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 5),
      child: simple.text("$value", color: color));
}
