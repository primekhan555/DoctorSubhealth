import 'package:flutter/material.dart';
// import 'package:bezier_chart/bezier_chart.dart';
import 'package:http/http.dart' as http;
import 'package:subhealth_doctorapp/MainSection/ScheduleProbTabs.dart/ScheduleMain.dart';
import 'dart:convert' as convert;
import 'package:subhealth_doctorapp/Resources/simpleWidget.dart' as simple;
import 'package:subhealth_doctorapp/Resources/navigate.dart' as navigate;

class ScheduleTab extends StatefulWidget {
  ScheduleTab({Key key}) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  var data;
  getData() async {
    var response = await http.get("https://reqres.in/api/users?page=2");
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // print(jsonResponse);
      return jsonResponse["data"];
    } else
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
  }

  @override
  void initState() {
    data = getData();
    super.initState();
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
                    onTap: () => navigate.push(context,
                        ScheduleMain(name: snapshot.data[index]["first_name"])),
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
// Container(
//       margin: EdgeInsets.only(top: 20),
//       height: 200,
//       width: MediaQuery.of(context).size.width,
//       child: BezierChart(
//         bezierChartScale: BezierChartScale.MONTHLY,
//         fromDate: fromDate,
//         toDate: toDate,
//         selectedDate: toDate,
//         series: [
//           BezierLine(
//             // label: "Duty",
//             onMissingValue: (dateTime) {
//               if (dateTime.month.isEven) {
//                 return 10.0;
//               }
//               return 5.0;
//             },
//             dataPointFillColor: Colors.white,
//             dataPointStrokeColor: Colors.blue[900],
//             data: list,
//           ),
//         ],
//         config: BezierChartConfig(
//             verticalIndicatorStrokeWidth: 3.0,
//             verticalIndicatorColor: Colors.black26,
//             showVerticalIndicator: true,
//             verticalIndicatorFixedPosition: false,
//             displayDataPointWhenNoValue: false,
//             snap: true,
//             footerHeight: 40.0,
//             backgroundGradient: LinearGradient(
//                 colors: [Colors.purple, Colors.white],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter)),
//       ),
//     )

///
///  // final fromDate = DateTime(2018, 11, 22);
// final toDate = DateTime.now();
// static final date0 = DateTime.now().subtract(Duration(days: 120));
// static final date1 = DateTime.now().subtract(Duration(days: 90));
// static final date3 = DateTime.now().subtract(Duration(days: 60));
// static final date5 = DateTime.now().subtract(Duration(days: 30));

// List<DataPoint<DateTime>> list = [
//   DataPoint<DateTime>(value: 25.5, xAxis: date0),
//   DataPoint<DateTime>(value: 10, xAxis: date1),
//   DataPoint<DateTime>(value: 10, xAxis: date3),
//   DataPoint<DateTime>(value: 24, xAxis: date5),
// ];
