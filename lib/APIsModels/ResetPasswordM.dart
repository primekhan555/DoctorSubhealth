import 'package:flutter/foundation.dart';

class ResetPasswordM {
  String mobile;
  String newPassword;
  ResetPasswordM({@required this.mobile, @required this.newPassword});
  Map<String, String> body() {
    return {"mobile": mobile, "newPassword": newPassword};
  }
}
