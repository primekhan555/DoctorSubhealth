import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        child: ListTile(
          title: Text(
            "Notifications",
            style: TextStyle(color: colors.blue),
          ),
          trailing: Switch(
            value: toggle,
            onChanged: (value) {
              setState(() {
                toggle = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
