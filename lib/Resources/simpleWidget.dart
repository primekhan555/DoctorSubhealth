import 'package:flutter/material.dart';
import 'colors.dart' as colors;

icon(IconData icon, {Color color}) => Icon(
      icon,
      color: color ?? Colors.black,
    );
text(String text, {Color color, double fontSize, FontWeight fontWeight}) =>
    Text(
      "$text",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color ?? colors.black,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontFamily: "SFProDisplay"),
    );
container(Widget child, double height, double width,
        {double radius,
        Color color,
        Alignment alignment,
        Color borderColor,
        double margin}) =>
    Container(
      margin: EdgeInsets.only(top: margin ?? 0.0),
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? colors.transparent),
          color: color,
          borderRadius: BorderRadius.circular(radius ?? 0)),
      height: height,
      width: width,
      child: child,
    );
