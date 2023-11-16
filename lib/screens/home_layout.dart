import 'dart:math';

import 'package:ads/screens/campaign_create_page.dart';
import 'package:ads/screens/home_page.dart';
import 'package:ads/screens/settings_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class HomeLayout extends StatefulWidget {
  static const String routeName = "/home";
  const HomeLayout() : super();
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<HomeLayout> {
  String _appTitle = "Business Manager";
  String? _currentRoute = HomePage.routeName;
  @override
  void initState() {
    super.initState();
  }

  Widget view() {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(_appTitle),
        centerTitle: _currentRoute == HomePage.routeName ? false : true,
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        actions: [
          _currentRoute == HomePage.routeName
              ? Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          Utils.mainListNav.currentState
                              ?.pushNamed(CampaignCreatePage.routeName);
                        },
                        child: Ink(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                )
              : SizedBox()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    color: const Color.fromARGB(255, 199, 196, 196),
                    width: 1.0))),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image.asset(
                  _currentRoute == HomePage.routeName
                      ? "assets/icons/home-active.png"
                      : "assets/icons/home.png",
                  width: 25,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Image.asset(
                  _currentRoute == CampaignCreatePage.routeName
                      ? "assets/icons/graphic-active.png"
                      : "assets/icons/graphic.png",
                  width: 25,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Image.asset(
                  _currentRoute == SettingPage.routeName
                      ? "assets/icons/settings-active.png"
                      : "assets/icons/settings.png",
                  width: 25,
                ),
                label: ""),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.amber[800],
          onTap: (value) {
            if (value == 0) {
              setState(() {
                _appTitle = "Business Manager";
              });
              Utils.mainListNav.currentState?.pushNamed(HomePage.routeName);
            } else if (value == 1) {
              Utils.mainListNav.currentState
                  ?.pushNamed(CampaignCreatePage.routeName);
            } else if (value == 2) {
              Utils.mainListNav.currentState?.pushNamed(SettingPage.routeName);
            }

            // setState(() {
            //   _itemSelected = value;
            // })
          },
          // onTap: (value) {
          //   if (value == "1") {
          //     Navigator.pushNamed(context, CampaignCreatePage.routeName);
          //   }
          // },
        ),
      ),

      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Navigator(
            key: Utils.mainListNav,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              Widget page;

              if (settings.name != _currentRoute) {
                String appTitle = "Business Manager";

                if (settings.name == SettingPage.routeName) {
                  appTitle = "Settings";
                } else if (settings.name == CampaignCreatePage.routeName) {
                  appTitle = "Create Campaign";
                }
                setState(() {
                  _currentRoute = settings.name;
                  _appTitle = appTitle;
                });
              }

              switch (settings.name) {
                case '/':
                  page = HomePage();
                  break;
                case SettingPage.routeName:
                  page = SettingPage();
                  break;
                default:
                  page = CampaignCreatePage();
                  break;
              }

              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => page,
                transitionDuration: const Duration(seconds: 0),
              );
            },
          )),
        ],
      )),
      // #242527
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.view();
  }
}
