import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ads/screens/onboarding_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const storage = FlutterSecureStorage();

class Initialize extends StatefulWidget {
  static const String routeName = "/";
  const Initialize() : super();

  @override
  _ForeGroundState createState() => _ForeGroundState();
}

class _ForeGroundState extends State<Initialize> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      print("Navigate to onboarding...");
      Utils.mainAppNav.currentState?.pushNamed(Onboarding.routeName);
      // Navigator.of(context).pushNamed(context, HomeLayout.routeName);
    });
    return const WithForegroundTask(
      child: Scaffold(
        body: Text(''),
      ),
    );
  }
}
