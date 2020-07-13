import 'package:flutter/foundation.dart';

class Register {
  String phoneNumber;
  Register({@required this.phoneNumber});
  Map<String, String> body() {
    return {"mobile": phoneNumber};
  }
}
