import 'package:flutter/foundation.dart';

class RegisterationPost {
  String role;
  String username;
  String mobile;
  String fullname;
  String password;
  String dob;
  String gender;
  String address;
  String city;
  String province;
  String country;
  String cnic;
  String latitude;
  String longitude;
  RegisterationPost(
      {@required this.role,
      @required this.username,
      @required this.mobile,
      @required this.fullname,
      @required this.password,
      @required this.dob,
      @required this.gender,
      @required this.address,
      @required this.city,
      @required this.province,
      @required this.country,
      @required this.cnic,
      @required this.latitude,
      @required this.longitude});
  Map<String, String> body() {
    return {
      "role": role,
      "mobile": mobile,
      "username": username,
      "fullname": fullname,
      "password": password,
      "dob": dob,
      "gender": gender,
      "address": address,
      "city": city,
      "province": province,
      "country": country,
      "cnic": cnic,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
