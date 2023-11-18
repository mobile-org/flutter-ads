import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

class _ChartPageState extends State<ChartPage> {
  var onboardIndex = 0;
  var loginType = 2; // Don't show webview
  var isLoaded = false;
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
            List<_SalesData> data = campaigns.map((campaign) {
              return _SalesData(
                  DateFormat("dd/MM/yyyy").parse(campaign["date"].toString()),
                  Utils.stringToNumber(campaign["total_impression"]));
            }).toList();
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 60, left: 15, right: 15),
                    child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        series: <ChartSeries>[
                          // Renders line chart
                          LineSeries<_SalesData, DateTime>(
                              dataSource: data,
                              xValueMapper: (_SalesData sales, _) => sales.year,
                              yValueMapper: (_SalesData sales, _) =>
                                  sales.sales)
                        ])),
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
