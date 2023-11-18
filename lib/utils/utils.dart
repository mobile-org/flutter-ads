import 'dart:convert';

import 'package:ads/screens/initialize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static final GlobalKey<NavigatorState> mainListNav =
      GlobalKey(debugLabel: "_mainListKey");
  static final GlobalKey<NavigatorState> mainAppNav =
      GlobalKey(debugLabel: "_mainAppKey");

  static stringToNumber(String str) {
    return int.parse(
      str.replaceAll(",", ""),
    );
  }

  static numberToString(int num) {
    return NumberFormat.decimalPattern().format(num);
  }

  static geteCPM(int earned, int impression) {
    if (impression == 0 || earned == 0) {
      return 0;
    }
    var eCPM = earned / impression * 1000;
    return eCPM.toInt();
  }

  static getCampaigns() async {
    final campaigns = await storage.read(key: "campaigns");
    return (jsonDecode(campaigns!) ?? []) as List<dynamic>;
  }

  static bool isDate(String input, String format) {
    try {
      DateFormat(format).parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }
}
