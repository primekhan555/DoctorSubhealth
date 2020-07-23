import 'package:dio/dio.dart';

class UpdateDoctorProfile {
  String userId;
  String fullname;
  String dob;
  String gender;
  String address;
  String city;
  String province;
  String country;
  String cnic;
  String latitude;
  String longitude;
  String passportNo;
  String email;
  String medicalRegistrationNo;
  String specilityId;
  String description;
  String doctorinfo;
  String speciality;
  String qualification;
  String certificates;
  String hospitalAddress;
  String hospitalContact;
  MultipartFile profilePic;
  MultipartFile resume;
  MultipartFile signature;
  UpdateDoctorProfile(
      {this.fullname,
      this.dob,
      this.gender,
      this.address,
      this.city,
      this.province,
      this.country,
      this.cnic,
      this.latitude,
      this.longitude,
      this.userId,
      this.passportNo,
      this.email,
      this.description,
      this.specilityId,
      this.medicalRegistrationNo,
      this.doctorinfo,
      this.speciality,
      this.qualification,
      this.certificates,
      this.hospitalAddress,
      this.hospitalContact,
      this.profilePic,
      this.resume,
      this.signature});

  Map<String, dynamic> body() {
    return {
      "userId": userId,
      "fullname": fullname,
      "dob": dob,
      "gender": gender,
      "address": address,
      "city": city,
      "province": province,
      "country": country,
      "cnic": cnic,
      "latitude": latitude,
      "longitude": longitude,
      "passportNo": passportNo,
      "email": email,
      "medicalRegistrationNo": medicalRegistrationNo,
      "description": description,
      "specialityId": specilityId,
      "doctorinfo": doctorinfo,
      "specialInterest": speciality,
      "qualifications": qualification,
      "certificates": certificates,
      "hospitaladdress": hospitalAddress,
      "hospitalcontact": hospitalContact,
      "profilePic": profilePic,
      "doctorCV": resume,
      "doctorSignature": signature
    };
  }
}
