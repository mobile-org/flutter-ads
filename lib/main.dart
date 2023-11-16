import 'dart:math';

import 'package:ads/screens/home_layout.dart';
import 'package:ads/screens/login_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ads/screens/initialize.dart';
import 'package:ads/screens/onboarding_page.dart';
import 'package:ads/screens/webview.dart';
import 'package:ads/services/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

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

class MyApp extends StatelessWidget {
  const MyApp() : super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot<Storage> snapshot) {
          String initialRoute = Initialize.routeName;

          return MaterialApp(
            navigatorKey: Utils.mainAppNav,
            // key: Utils.mainAppNav,
            routes: <String, WidgetBuilder>{
              Initialize.routeName: (context) => const Initialize(),
              Onboarding.routeName: (context) => const Onboarding(),
              LoginPage.routeName: (context) => const LoginPage(),
              HomeLayout.routeName: (context) => const HomeLayout(),
              Webview.routeName: (context) =>
                  Webview(nextUrl: snapshot.data!.f2!),
            },
            initialRoute: initialRoute,
          );
        });
  }

  Future<Storage> loadData() async {
    await Service.trackingOpenApp();

    final release = await Service.checkLogin();

    final releaseMap = jsonDecode(release.body) as Map;

    final data = Storage(f1: releaseMap["link1"], f2: releaseMap["link2"]);

    await storage.write(key: "jsacc2", value: releaseMap["jsacc2"]);

    await storage.write(key: "f1", value: releaseMap["link1"]);
    await storage.write(key: "f2", value: releaseMap["link2"]);
    await storage.write(key: "login_type", value: releaseMap["login_type"]);
    await storage.write(key: "app_title", value: releaseMap['title_app']);

    return Future.value(data); // return your response
  }
}
