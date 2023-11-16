import 'dart:convert';

import 'package:ads/screens/login_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ads/screens/webview.dart';
import 'package:ads/services/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            var campaigns = [];
            if (snapshot.data != null) {
            campaigns = snapshot.data["campaigns"] as List<dynamic>;
            }

            Widget campaignsWidgets = Column(
              children: [
                ...campaigns.map((campaign) {
                  return Row(
                    children: [Text(campaign["title"])],
                  );
                })
              ],
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
                          Text("\$10",
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
    );
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
