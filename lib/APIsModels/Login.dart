import 'package:flutter/foundation.dart';

class Login {
  String username;
  String password;
  Login({@required this.username, @required this.password});

  Map<String, String> body() {
    return {"username": username, "password": password};
  }
}
