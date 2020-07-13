import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:subhealth_doctorapp/Globals/globals.dart' as globals;

Future get(String key) async {
  var res = await http.get("${globals.baseUrl}$key");
  int data = res.statusCode;
  if (data == 200) {
    var decode = convert.jsonDecode(res.body);
    return decode;
  } else {
    print("error");
  }
}
