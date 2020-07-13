import 'package:flutter/foundation.dart';

class UserName {
  String userName;
  UserName({@required this.userName});
  Map<String, String> body() {
    return {"username": userName};
  }
}
