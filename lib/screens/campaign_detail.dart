// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_interpolation_to_compose_strings, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_is_empty, library_private_types_in_public_api

import 'dart:convert';

import 'package:ads/screens/campaign_create_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dash/flutter_dash.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class CampaignDetail extends StatefulWidget {
  static const String routeName = "/campaign/detail";
  const CampaignDetail() : super();
  @override
  _CampaignDetailState createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
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

            var campaign = {
              "title": "xxx",
              "total_earning": "0",
              "total_impression": "0"
            };

            Widget campaignsWidgets = Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
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
                                  "0",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
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
                                  "0",
                                  style: TextStyle(fontSize: 12),
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
                            length: 70,
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
                                  campaign["total_earning"]!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
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
                                  campaign["total_impression"]!,
                                  style: TextStyle(fontSize: 12),
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
              children: [campaignsWidgets],
            ));
          }),
      // #242527
    ));
  }

  @override
  Widget build(BuildContext context) {
    return view();
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
