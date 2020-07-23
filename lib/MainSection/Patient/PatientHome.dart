import 'package:flutter/material.dart';

class PatientHome extends StatefulWidget {
  PatientHome({Key key}) : super(key: key);

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Patient"),
      ),
    );
  }
}
