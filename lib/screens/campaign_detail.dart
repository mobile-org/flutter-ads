// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_interpolation_to_compose_strings, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_is_empty, library_private_types_in_public_api

import 'dart:convert';

import 'package:ads/screens/campaign_create_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:go_router/go_router.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class CampaignDetail extends StatefulWidget {
  String? id;
  CampaignDetail({Key? key, required this.id}) : super(key: key);
  @override
  _CampaignDetailState createState() => _CampaignDetailState(id);
}

class _CampaignDetailState extends State<CampaignDetail> {
  String? id;
  _CampaignDetailState(this.id);
  @override
  void initState() {
    super.initState();
  }

  Widget view() {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            var campaigns = snapshot.data["campaigns"] as List<dynamic>;
            dynamic campaign = {};
            if (snapshot.data != null) {
              campaign = snapshot.data["campaign"];
            }

            var list = campaign["list"] as List<dynamic>;

            var totalEarned = list
                .map<int>((l) => Utils.stringToNumber(l["earned"]))
                .fold(0, (p, c) => p + c);

            var totalImpression = list
                .map<int>((l) => Utils.stringToNumber(l["total_impression"]))
                .fold(0, (p, c) => p + c);

            var realityECPM = Utils.geteCPM(totalEarned, totalImpression);
            var targetECPM = Utils.geteCPM(
                Utils.stringToNumber(campaign["total_earning"]),
                Utils.stringToNumber(campaign["total_impression"]));

            Widget campaignsWidgets = Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                decoration: BoxDecoration(
                  // color: Colors.grey,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      new Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "Reality",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/coin.png",
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Text(
                                  Utils.numberToString(totalEarned),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/show.png",
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Text(
                                  Utils.numberToString(totalImpression),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("eCPM = "),
                                SizedBox(
                                  width: 4,
                                ),
                                new Text(
                                  realityECPM.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Dash(
                            direction: Axis.vertical,
                            dashLength: 2,
                            length: 110,
                            dashColor: Colors.grey),
                      ),
                      new Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "Target",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/coin.png",
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Text(
                                  campaign["total_earning"] ?? "0",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/show.png",
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Text(
                                  campaign["total_impression"] ?? "0",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("eCPM = "),
                                SizedBox(
                                  width: 4,
                                ),
                                new Text(
                                  targetECPM.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));

            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 15, left: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 100,
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextButton(
                                        child: const Text('Edit'),
                                        onPressed: () {
                                          print(campaign["id"].toString());
                                          Navigator.pop(context);
                                          GoRouter.of(context).pushNamed(
                                              "create-campaign",
                                              pathParameters: {
                                                "id": campaign["id"].toString()
                                              });
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () async {
                                          var newCampaigns = campaigns
                                              .where((element) =>
                                                  element["id"] !=
                                                  campaign["id"])
                                              .toList();
                                          await storage.write(
                                              key: "campaigns",
                                              value: jsonEncode(newCampaigns));
                                          Navigator.pop(context);
                                          GoRouter.of(context)
                                              .pushNamed("home");
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                campaignsWidgets,
                Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
                  child: Text(
                    "History",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                buildHistory(campaign),
              ],
            ));
          }),
      // #242527
    ));
  }

  @override
  Widget build(BuildContext context) {
    return view();
  }

  Widget buildHistory(dynamic campaign) {
    List<String> tableHeaders = [
      "Date",
      "Impression",
      "eCPM",
      "Revenue Earned"
    ];

    final list = campaign["list"] as List<dynamic>;
    List<Widget> headerWidgets = tableHeaders.map((header) {
      return TableCell(
          child: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Text(
          header,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ));
    }).toList();

    List<TableRow> dataWidgets = list.map((l) {
      return TableRow(decoration: BoxDecoration(), children: [
        TableCell(
            child: Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(l["date"] ?? "", style: TextStyle(fontSize: 12)),
        )),
        TableCell(
            child: Container(
          padding: EdgeInsets.only(bottom: 15),
          child:
              Text(l["total_impression"] ?? "", style: TextStyle(fontSize: 12)),
        )),
        TableCell(
            child: Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(geteCPM(l["earned"], l["total_impression"]),
              style: TextStyle(fontSize: 12)),
        )),
        TableCell(
            child: Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(l["earned"] ?? "", style: TextStyle(fontSize: 12)),
        ))
      ]);
    }).toList();
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Table(
              children: [TableRow(children: headerWidgets), ...dataWidgets],
            )),
        list.length == 0
            ? Container(
                padding: EdgeInsets.only(top: 60, bottom: 60),
                child: Text(
                  "No Revenue",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            : SizedBox(),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: ElevatedButton(
            child: Text(
              "Enter actual revenue",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                // side: BorderSide(color: Colors.red)
              ),
            ),
            onPressed: () {
              GoRouter.of(context)
                  .pushNamed("earning", pathParameters: {"id": id.toString()});
            },
          ),
        )
      ],
    );
  }

  geteCPM(String totalEarning, String totalImpression) {
    var eCPM = int.parse(totalEarning.replaceAll(",", "")) /
        int.parse(
          totalImpression.replaceAll(",", ""),
        ) *
        1000;
    return eCPM != 0 ? eCPM.toInt().toString() : "0";
  }

  Future fetchData() async {
    final campaigns = await storage.read(key: "campaigns");
    final arr = jsonDecode(campaigns!) as List<dynamic>;
    final campaign =
        arr.firstWhere((element) => element["id"].toString() == id);

    return Future.value({
      "campaign": campaign,
      "campaigns": arr,
    });

    // if (!isLoaded) {
    //   final response = await Service.checkLogin();
    //   final body = jsonDecode(response.body) as Map;
    //   if (int.parse(body['login_type']) != 1) {
    //     _controller.onboardingPages
    //         .add(OnboardingInfo('assets/gif/5.png', 'Ads Manager Helper'));
    //   }
    //   setState(() {
    //     isLoaded = true;
    //   });
    // }
  }
}
