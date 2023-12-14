import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class ChartPage extends StatefulWidget {
  const ChartPage() : super();
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final DateTime year;
  final int sales;
}

class Tuple {
  final dynamic item1;
  final dynamic item2;

  Tuple(this.item1, this.item2);
}

const List<String> list = <String>[
  'Today',
  'Yesterday',
  'This week',
  'Last week',
  'Last 7 days',
  'Last 30 days',
  'This month',
  'Last month',
  'This year',
  'Last year'
];

class _ChartPageState extends State<ChartPage> {
  var onboardIndex = 0;
  var loginType = 2; // Don't show webview
  var isLoaded = false;
  String dropdownValue = list.first;
  @override
  void initState() {
    super.initState();
  }

  Widget view() {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            var campaigns = [] as List<dynamic>;
            if (snapshot.data != null) {
              campaigns = snapshot.data["campaigns"];
            }

            final List<Map<String, dynamic>> dataS = campaigns.map((campaign) {
              DateFormat dateFormat = DateFormat("yyyy-MM-dd");
              DateFormat dateFormat1 = DateFormat("dd/MM/yyyy");
              String d = dateFormat.format(dateFormat1.parse(campaign["date"]));

              var list = campaign["list"] as List<dynamic>;
              var totalRevenue = list
                  .map<int>((l) => Utils.stringToNumber(l["earned"]))
                  .fold(0, (p, c) => p + c);
              return {"date": d, "value": totalRevenue};
            }).toList();

            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 0, bottom: 0, right: 15)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 10,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: DefaultTabController(
                    length: 2,
                    child: TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            "Revenue Earning",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Impression",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(top: 60, left: 15, right: 15),
                  child: SfCartesianChart(
                    // title: ChartTitle(text: 'Date-Value Chart'),
                    // legend: Legend(isVisible: true),
                    primaryXAxis: DateTimeAxis(
                        // title: AxisTitle(text: 'Date'),
                        ),
                    primaryYAxis: NumericAxis(
                        // title: AxisTitle(text: 'Value'),
                        ),
                    series: <ChartSeries>[
                      LineSeries<Map<String, dynamic>, DateTime>(
                        dataSource: dataS,
                        xValueMapper: (Map<String, dynamic> point, _) =>
                            DateTime.parse(point['date']),
                        yValueMapper: (Map<String, dynamic> point, _) =>
                            point['value'].toDouble(),
                        // name: 'Date-Value Series',
                      ),
                    ],
                  ),
                ),
              ],
            ));
          }),
      // #242527
    );
  }

  Widget settingItemWidget({String label = "", String icon = ""}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xffE6E6E6),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(children: [
        Image.asset(
          icon,
          width: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.view();
  }

  Future getData() async {
    return Future.value({"campaigns": await Utils.getCampaigns()});
  }
}
