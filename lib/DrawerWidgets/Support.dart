import 'package:flutter/material.dart';
import 'package:subhealth_doctorapp/Resources/colors.dart' as colors;

class Support extends StatefulWidget {
  Support({Key key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  List<String> items = ["Chat", "Call", "Email"];
  List<IconData> itemsIcons = [Icons.chat, Icons.call, Icons.email];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(itemsIcons[index]),
              title: Text("${items[index]}"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }
}
