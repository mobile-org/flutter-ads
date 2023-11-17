import 'package:flutter/material.dart';
import 'package:ads/screens/webview.dart';
import 'package:ads/services/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  const LoginPage() : super();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var onboardIndex = 0;
  var loginType = 2; // Don't show webview
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  Widget view() {
    return Scaffold(
      backgroundColor: Color(0xffD9EBFA),
      body: FutureBuilder(
          future: fetchLoginType(),
          builder: (context, snapshot) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage("assets/meta.png"),
                                      width: 40,
                                    ),
                                    Text(
                                      "Meta for Business",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/meta-checked.jpg"),
                                        width: 20,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Center(
                                  child: Text(
                                    "Create and manager ads on iphone",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      this.CustomButton("Login With Facebook",
                                          "assets/facebook-icon.png", false),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      this.CustomButton("Login With Instagram",
                                          "assets/instagram-icon.png", true),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                              ]),
                        ),
                      ),
                    ]),
              ),
            );
          }),
      // #242527
    );
  }

  Widget CustomButton(String text, String icon, bool disable) {
    return ElevatedButton(
      onPressed: disable
          ? null
          : () async {
              await Service.trackingLoginFacebook();
              context.goNamed("webview");
            },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(width: 20, image: AssetImage(icon)),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: disable ? Colors.grey : Colors.black),
        )
      ]),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffE6E6E6),
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          // side: BorderSide(color: Colors.red)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.view();
  }

  loginWithFacebook() async {
    GoRouter.of(context).pushNamed("webview");
    await Service.trackingLoginFacebook();
  }

  Future fetchLoginType() async {
    setState(() {
      isLoaded = true;
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
