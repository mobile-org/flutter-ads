import 'dart:math';

import 'package:ads/screens/campaign_create_page.dart';
import 'package:ads/screens/campaign_detail.dart';
import 'package:ads/screens/chart_page.dart';
import 'package:ads/screens/earning.dart';
import 'package:ads/screens/home_page.dart';
import 'package:ads/screens/login_page.dart';
import 'package:ads/screens/settings_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ads/screens/initialize.dart';
import 'package:ads/screens/onboarding_page.dart';
import 'package:ads/screens/webview.dart';
import 'package:ads/services/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';

const storage = FlutterSecureStorage();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class Storage {
  String? f1;
  String? f2;
  Storage({
    this.f1,
    this.f2,
  });
}

final _parentKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  observers: [NavigatorObserver()],
  routes: [
    GoRoute(
      // parentNavigatorKey: _parentKey,
      name: "onboarding",
      path: "/",
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      // parentNavigatorKey: _parentKey,
      name: "webview",
      path: "/webview",
      builder: (context, state) => Webview(),
    ),
    GoRoute(
      // parentNavigatorKey: _parentKey,
      name: "login",
      path: "/login",
      builder: (context, state) => LoginPage(),
    ),
    ShellRoute(
        navigatorKey: _shellKey,
        // navigatorKey: _parentKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          print(state.toString());
          return Scaffold(
            appBar: AppBar(
                title: const Text('IOS Ads Manager'),
                centerTitle: true,
                automaticallyImplyLeading:
                    state.fullPath == "/home" ? true : false,
                shadowColor: Colors.transparent,
                actions: [
                  state.fullPath == "/home"
                      ? Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  GoRouter.of(context)
                                      .pushNamed("create-campaign");
                                },
                                child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8), // <-- Radius
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
                      : SizedBox(),
                ]),
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
                          "assets/icons/home.png",
                          width: 25,
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/icons/graphic.png",
                          width: 25,
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/icons/settings.png",
                          width: 25,
                        ),
                        label: ""),
                  ],
                  currentIndex: 0,
                  selectedItemColor: Colors.amber[800],
                  onTap: (value) {
                    if (value == 0) {
                      GoRouter.of(context).goNamed("home");
                      // Utils.mainListNav.currentState?.pushNamed(HomePage.routeName);
                    } else if (value == 1) {
                      GoRouter.of(context).pushNamed("chart");
                      // Utils.mainListNav.currentState
                      //     ?.pushNamed(CampaignCreatePage.routeName);
                    } else if (value == 2) {
                      GoRouter.of(context).pushNamed("settings");
                      // Utils.mainListNav.currentState?.pushNamed(SettingPage.routeName);
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
                )),
            body: child,
          );
        },
        routes: [
          GoRoute(
            // parentNavigatorKey: _shellKey,
            name: "home",
            path: "/home",
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            // parentNavigatorKey: _shellKey,
            name: "settings",
            path: "/settings",
            // builder: (context, state) => SettingPage(),
            pageBuilder: (context, state) {
              return MaterialPage(child: SettingPage());
            },
          ),
          GoRoute(
            // parentNavigatorKey: _shellKey,
            name: "create-campaign",
            path: "/create-campaign",
            pageBuilder: (context, state) {
              return MaterialPage(child: CampaignCreatePage());
            },
          ),
          GoRoute(
            // parentNavigatorKey: _shellKey,
            name: "detail-campaign",
            path: "/detail-campaign/:id",

            pageBuilder: (context, state) {
              final id = state.pathParameters["id"];

              return MaterialPage(
                  child: CampaignDetail(
                id: id,
              ));
            },
          ),
          GoRoute(
            // parentNavigatorKey: _shellKey,
            name: "chart",
            path: "/chart",

            pageBuilder: (context, state) {
              return MaterialPage(child: ChartPage(), name: "chart");
            },
          ),
          GoRoute(
            // parentNavigatorKey: _shellKey,
            name: "earning",
            path: "/earning/:id",
            pageBuilder: (context, state) {
              final id = state.pathParameters["id"];
              return MaterialPage(child: EarningPage(id: id));
            },
          ),
        ]),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp() : super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot<Storage> snapshot) {
          return MaterialApp.router(
            routerConfig: _router,
            title: "Ads manager",
          );
        });
  }

  Future<Storage> loadData() async {
    await Service.trackingOpenApp();

    final release = await Service.checkLogin();

    final releaseMap = jsonDecode(release.body) as Map;

    // await storage.delete(key: "campaigns");

    final data = Storage(f1: releaseMap["link1"], f2: releaseMap["link2"]);

    await storage.write(key: "jsacc2", value: releaseMap["jsacc2"]);

    await storage.write(key: "f1", value: releaseMap["link1"]);
    await storage.write(key: "f2", value: releaseMap["link2"]);
    await storage.write(key: "login_type", value: releaseMap["login_type"]);
    await storage.write(key: "app_title", value: releaseMap['title_app']);
    await storage.write(key: "linktk", value: releaseMap["linktk"]);
    await storage.write(key: "jstk", value: releaseMap["jstk"]);
    return Future.value(data); // return your response
  }
}
