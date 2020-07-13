import 'package:flutter/material.dart';

logo() => Image.asset('assets/images/logo1.png');

logoCont({double height, double marginBottom, double marginTop}) => Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(bottom: marginBottom ?? 50, top: marginTop ?? 100),
    height: height ?? 100,
    child: logo());
