import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;

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
  File file;
  DateTime dateToday = DateTime.now();
  String pickedDate;
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
            simple.text("${globals.fullName}", fontSize: 20),
            divider(color: colors.blue),
            textField(globals.fullName, "name", true),
            textField("${globals.userName}", "username", false),
            textField("${globals.email ?? ""}", "email", true),
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
                          globals.changes = true;
                          globals.gender = 0;
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
                          globals.changes = true;

                          globals.gender = 1;
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
                          globals.changes = true;

                          globals.gender = 2;
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
                      globals.changes = true;
                      pickedDate = formatedDate;
                      globals.dob = formatedDate;
                    });
                  }
                },
                child: container(globals.dob == "null"
                    ? "Date of Birth"
                    : pickedDate ?? globals.dob)), //pickedDate)),
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
                                      globals.latitude =
                                          position.target.latitude.toString();
                                      globals.longitude =
                                          position.target.longitude.toString();
                                      globals.changes = true;
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
                                                  globals.latitude = value[0]
                                                      .position
                                                      .latitude
                                                      .toString();
                                                  globals.longitude = value[0]
                                                      .position
                                                      .longitude
                                                      .toString();
                                                  globals.changes = true;
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
                                        globals.address = first.addressLine;
                                        globals.city = first.subAdminArea;
                                        globals.province = first.adminArea;
                                        globals.country = first.countryName;
                                        globals.changes = true;
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
            textField("${globals.cnic}", "nic", true,
                keyboardType: TextInputType.number, limit: 13),
            textField(
                "${globals.passport == "null" ? "" : globals.passport ?? ""}",
                "passport",
                true,
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
                          : fieldType == "email" ? "email" : "Passport"),
              enabled: enabled,
              onChanged: (value) {
                globals.changes = true;
                setState(() {
                  if (fieldType == "name") {
                    name = value;
                    globals.changes = true;
                    globals.fullName = value;
                  } else if (fieldType == "passport") {
                    globals.passport = value;
                    globals.changes = true;
                  } else if (fieldType == "nic") {
                    globals.cnic = value;
                    globals.changes = true;
                  } else if (fieldType == "email") {
                    globals.email = value;
                  }
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
    globals.changes = true;
    final picture = await picker.getImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
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
    String path;
    path = croppedImage.path;
    String fileName = croppedImage.path.split("/").last;
    globals.image = await MultipartFile.fromFile(path, filename: fileName);

    // try {
    //   final bytes = await compute(compress, croppedImage.readAsBytesSync());
    //   log("tttttttttttttttttt ${uri.path}");
    // final url = Uri.parse("http://3.12.222.146:4000/api/filupload");
    //   var request = http.MultipartRequest(
    //     'POST',
    //     url,
    //   )..files.add(
    //       new http.MultipartFile.fromBytes("image", bytes, filename: fileName),
    //     );
    //   var res = await request.send();
    //   log("${res.statusCode}");
    // } catch (e) {
    //   log("================================${e.toString()}");
    // }
    //////////////////////////

    // http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    // // request.fields['api_key'] = 'apiKey';
    // // request.fields['api_secret'] = 'apiSecret';
    // request.files.add(await http.MultipartFile.fromPath(
    //     'image', croppedImage.path,
    //     contentType: new MediaType('image', 'jpg')));
    // // request.files.add(await http.MultipartFile.fromPath(
    // //     'image_file2', second.path,
    // //     contentType: new MediaType('application', 'x-tar')));
    // http.StreamedResponse response = await request.send();
    // log("${response.statusCode}");

    ///////////////////////////////////

    // Dio dio = Dio();

    // try {
    //   FormData formData = new FormData.fromMap({
    //     "image": await MultipartFile.fromFile(
    //       croppedImage.path,
    //       filename: fileName,
    //     ), // contentType: MediaType("image", "jpg")),
    //     "name": "faisal"
    //   });
    //   // Map<String, dynamic> formData = {
    //   //   "image": await MultipartFile.fromFile(file.path, filename: fileName),
    //   // };

    //   Response response = await dio.post(
    //       "http://3.12.222.146:4000/api/filupload",
    //       data: formData,
    //       options: Options(headers: {"content-Type": "multipart/form-data"}));
    //   log("${response.statusCode}");
    //   log("${response.data.toString()}");
    // } catch (e) {
    //   log("+++++++++++++++++++++++++++++++");
    // }
    ////////////////////
    // var stream =
    //     new http.ByteStream(DelegatingStream.typed(croppedImage.openRead()));
    // var length = await croppedImage.length();

    // var uri = Uri.parse(uploadURL);

    // var request = new http.MultipartRequest("POST", uri);
    // var multipartFile = new http.MultipartFile('file', stream, length,
    //     filename: basename(croppedImage.path));
    // //contentType: new MediaType('image', 'png'));

    // request.files.add(multipartFile);
    // var response = await request.send();
    // print(response.statusCode);
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
  }

  // String fileName = croppedImage.path.split("/").last;
  List<int> compress(List<int> bytes) {
    var image = img.decodeImage(bytes);
    var resize = img.copyResize(image, width: 480);
    return img.encodePng(resize);
  }
}
