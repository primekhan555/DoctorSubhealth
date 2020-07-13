import 'package:flutter/material.dart';

push(BuildContext context, Widget screen) {
  var route = MaterialPageRoute(builder: (context) => screen);
  Navigator.push(context, route);
}

pushRemove(BuildContext context, Widget screen) {
  var newRoute = MaterialPageRoute(builder: (context) => screen);
  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
}
