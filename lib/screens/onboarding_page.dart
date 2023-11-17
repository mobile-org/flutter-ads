import 'package:ads/screens/home_layout.dart';
import 'package:ads/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class Onboarding extends StatefulWidget {
  static const String routeName = "/onboarding";
  const Onboarding() : super();
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  var onboardIndex = 0;
  var loginType = 2; // Don't show webview
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  Widget view() {
    final List texts = [
      {
        "title": "Capaign updates",
        "description":
            "The status of your campaigns: approval, ending and perfirmance."
      },
      {
        "title": "Alerts",
        "description":
            "Errors blocking your campaigns: ad rejection, billing issues, or reaching your spending limit."
      },
      {
        "title": "Best for beginners",
        "description":
            "Essential notifications for those starting out on Ads Manager."
      },
      {
        "title": "Performance opportunities",
        "description": "Suggestions to improve campaign performanca."
      }
    ];
    List<Widget> widgets = texts
        .map((text) => Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: true,
                  checkColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(
                        width: 1.0, color: Color(0xffaaaaaa), strokeAlign: 3),
                  ),
                  activeColor: Colors.transparent,
                  onChanged: (value) => {},
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text["title"],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        text["description"],
                        style: TextStyle(color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            )))
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xff242527),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Stack(
                  children: [
                    Text(
                      "Turn on push notifications to stay updated",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ...widgets,
                const Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 0.5, color: const Color(0xffaaaaaa)),
                  )),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "You can make changes in settings any time.",
                          style: TextStyle(color: const Color(0xffaaaaaa)),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1a78f4),
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                // side: BorderSide(color: Colors.red)
                              )),

                          // #1a78f4
                          onPressed: () async {
                            var loginType =
                                await storage.read(key: "login_type");
                            if (loginType == "1") {
                              Navigator.pushNamed(
                                  context, HomeLayout.routeName);
                            } else {
                              Navigator.pushNamed(context, LoginPage.routeName);
                            }
                          },
                          child: const Text('Continue',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        )
                      ]),
                )
              ],
            )),
      ),
      // #242527
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.view();
  }
}
