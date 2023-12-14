// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_interpolation_to_compose_strings, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_is_empty, library_private_types_in_public_api

import 'dart:convert';

import 'package:ads/screens/campaign_create_page.dart';
import 'package:ads/screens/campaign_detail.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ads/services/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class HomePage extends StatefulWidget {
  static const String routeName = "/";
  const HomePage() : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var onboardIndex = 0;
  var loginType = 2; // Don't show webview
  var isLoaded = false;
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
            var campaigns = [];
            if (snapshot.data != null) {
              campaigns = snapshot.data["campaigns"] as List<dynamic>;
            }

            var totalRevenue = campaigns.map<int>((campaign) {
              var list = campaign["list"] as List<dynamic>;
              return list
                  .map<int>((l) => Utils.stringToNumber(l["earned"]))
                  .fold(0, (p, c) => p + c);
            }).fold(0, (p, c) => p + c);

            Widget campaignsWidgets = Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...campaigns.map((campaign) {
                    var list = campaign["list"] as List<dynamic>;

                    var realityTotalEarned = list
                        .map<int>((l) => Utils.stringToNumber(l["earned"]))
                        .fold(0, (p, c) => p + c);
                    var realityTotalImpression = list
                        .map<int>(
                            (l) => Utils.stringToNumber(l["total_impression"]))
                        .fold(0, (p, c) => p + c);

                    return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).goNamed("detail-campaign",
                              pathParameters: {
                                "id": campaign["id"].toString()
                              });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      campaign["title"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.blue),
                                    ),
                                    Text(
                                      "End date: " + campaign["date"],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          new Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Text(
                                                  "Reality",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                      Utils.numberToString(
                                                          realityTotalEarned),
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                      Utils.numberToString(
                                                          realityTotalImpression),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Dash(
                                                direction: Axis.vertical,
                                                dashLength: 2,
                                                length: 70,
                                                dashColor: Colors.grey),
                                          ),
                                          new Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Text(
                                                  "Target",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                      campaign["total_earning"],
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                      campaign[
                                                          "total_impression"],
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ));
                  })
                ],
              ),
            );

            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
                  color: Colors.blue,
                  child: Center(
                      child: Container(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Revenue",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("\$" + Utils.numberToString(totalRevenue),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ]),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  )),
                ),
                SizedBox(
                  height: campaigns.length == 0 ? 140 : 10,
                ),
                campaigns.length == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/icons/big-data.png",
                              width: 100,
                            ),
                          ),
                          Text(
                            "No Campaigns Yets",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Container(
                              child: Text(
                                'Tap the button " + " sign to create your first campaigns',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : campaignsWidgets
              ],
            ));
          }),
      // #242527
    ));
  }

  @override
  Widget build(BuildContext context) {
    return this.view();
  }

  Future fetchData() async {
    final campaigns = await storage.read(key: "campaigns");

    return Future.value({
      "campaigns": jsonDecode(campaigns!) ?? [],
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
