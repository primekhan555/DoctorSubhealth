import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HistoryTab extends StatefulWidget {
  HistoryTab({Key key}) : super(key: key);

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  var data;
  getData() async {
    var response = await http.get("https://reqres.in/api/users?page=2");
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse["data"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: simple.text("${snapshot.data[index]["first_name"]}"),
                    subtitle:
                        simple.text("${snapshot.data[index]["first_name"]}"),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage("${snapshot.data[index]["avatar"]}"),
                    ),
                    trailing:
                        simple.text("${snapshot.data[index]["last_name"]}"));
              },
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    ));
  }
}
