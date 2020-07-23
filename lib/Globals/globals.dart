import 'package:dio/dio.dart';

String baseUrl = "http://3.12.222.146:4000/";
String uid;
String profilePic;
String fullName;
String number;
String userName;
String id;
String userId;
String cnic;
String address;
String country;
String province;
String city;
String dob;
String passport;
int gender;
int acountStatus;
String latitude;
String longitude;
String email;
String registerationNo;
String consultant;
String speciality;
String emailUpdating;
String secondPageChange;
String specialityName;
String hospitalAddress;
String hospitalNumber;

List specialMapList = [];
List qualMapList = [];
List certificateMapList = [];
MultipartFile image;
MultipartFile cv;
MultipartFile signature;

///detecting changes
bool changes = false;
