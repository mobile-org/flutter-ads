import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class SettingPage extends StatefulWidget {
  static const String routeName = "/pages/settings";
  const SettingPage() : super();
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          future: fetchLoginType(),
          builder: (context, snapshot) {
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      this.settingItemWidget(
                          icon: "assets/icons/email.png", label: "Contact Us"),
                      SizedBox(
                        height: 20,
                      ),
                      this.settingItemWidget(
                          icon: "assets/icons/share.png", label: "Share App"),
                      SizedBox(
                        height: 20,
                      ),
                      this.settingItemWidget(
                          icon: "assets/icons/security-shield.png",
                          label: "Privacy Policy"),
                      SizedBox(
                        height: 20,
                      ),
                      this.settingItemWidget(
                          icon: "assets/icons/document.png",
                          label: "Terms Of User")
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

  Future fetchLoginType() async {
    setState(() {
      isLoaded = true;
    });
  }
}
