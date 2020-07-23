import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

showFlushbar(String message, var context, Color color, {int duration}) {
  Flushbar(
    message: "$message",
    backgroundColor: color,
    duration: Duration(milliseconds: duration ?? 1500),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
  )..show(context);
}

showToast(BuildContext context, String message, int loc) {
  return Toast.show("$message", context,
      duration: Toast.LENGTH_SHORT, gravity: loc);
}
