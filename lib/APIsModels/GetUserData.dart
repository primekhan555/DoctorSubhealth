import 'package:flutter/foundation.dart';

class GetUserData {
  String userId;
  GetUserData({@required this.userId});
  Map<String, String> body() {
    return {"userId": userId};
  }
}
