import 'package:ads/screens/home_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ads/screens/webview.dart';
import 'package:ads/services/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'dart:convert';

const storage = FlutterSecureStorage();

class Campaign {
  final String title;
  final String total_earning;
  final String total_impression;
  final String date;
  Campaign(this.title, this.total_earning, this.total_impression, this.date);
}

class Introduce {
  final String title;
  Introduce(this.title);
}

class CampaignCreatePage extends StatefulWidget {
  static const String routeName = "/pages/campain_create_page";
  const CampaignCreatePage() : super();
  @override
  _CampaignCreatePageState createState() => _CampaignCreatePageState();
}

class _CampaignCreatePageState extends State<CampaignCreatePage> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final totalEarningController = TextEditingController();
  final totalImpressionController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  String eCPM = "0";
  @override
  void initState() {
    super.initState();
    totalEarningController.addListener(() {
      setState(() {
        eCPM = geteCPM();
      });
    });

    totalImpressionController.addListener(() {
      setState(() {
        eCPM = geteCPM();
      });
    });

    myFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    titleController.dispose();
    dateController.dispose();
    totalEarningController.dispose();
    totalImpressionController.dispose();
    super.dispose();
  }

  Widget view() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: fetchLoginType(),
              builder: (context, snapshot) {
                return SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 30, right: 30),
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        this.TextFieldInput(
                            label: "Campaign",
                            hintText: "Ex: Appname, website",
                            focusNode: myFocusNode,
                            controller: titleController),
                        SizedBox(
                          height: 20,
                        ),
                        this.TextFieldInput(
                          label: "Expected & Date",
                          keyboardType: TextInputType.datetime,
                          controller: dateController,
                          onTap: () async {
                            final picker = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                              onDatePickerModeChange: (value) {},
                            );

                            dateController.text = picker!.day.toString() +
                                '/' +
                                picker!.month.toString() +
                                '/' +
                                picker!.year.toString();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        this.TextFieldInput(
                            label: "Target Total Earning",
                            hintText: "Ex: \$10,000",
                            controller: totalEarningController,
                            keyboardType: TextInputType.number),
                        SizedBox(
                          height: 20,
                        ),
                        this.TextFieldInput(
                            label: "Target Total Impression",
                            hintText: "Ex: 10,000",
                            controller: totalImpressionController,
                            keyboardType: TextInputType.number),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "eCPM = " + eCPM,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // side: BorderSide(color: Colors.red)
                                ),
                              ),
                              onPressed: saveData,
                            )
                          ],
                        )
                      ]),
                    ),
                  ],
                ));
              }),
          // #242527
        ));
  }

  geteCPM() {
    var eCPM = int.parse(totalEarningController.text.replaceAll(",", "")) /
        int.parse(
          totalImpressionController.text.replaceAll(",", ""),
        ) *
        1000;
    return eCPM != 0 ? eCPM.toInt().toString() : "0";
  }

  saveData() async {
    if (titleController.text == "" ||
        totalEarningController.text == "" ||
        totalImpressionController.text == "" ||
        dateController.text == "") {
      return;
    }
    var campaignsStr = await storage.read(key: "campaigns");

    print(campaignsStr);

    final campaigns =
        campaignsStr != null ? jsonDecode(campaignsStr) as List<dynamic> : [];
    campaigns.add({
      "title": titleController.text,
      "total_earning": totalEarningController.text,
      "total_impression": totalImpressionController.text,
      "date": dateController.text,
    });

    var campaignsJSON = jsonEncode(campaigns);

    await storage.write(key: "campaigns", value: campaignsJSON);

    Utils.mainListNav.currentState?.pushNamed(HomePage.routeName);
    // await storage.write(key: "", value: value)
  }

  @override
  Widget build(BuildContext context) {
    return this.view();
  }

  Widget TextFieldInput(
      {String label = "",
      TextInputType keyboardType = TextInputType.text,
      String hintText = "",
      TextEditingController? controller,
      FocusNode? focusNode,
      void Function()? onTap}) {
    List<TextInputFormatter> inputFormatters = [];

    if (keyboardType == TextInputType.number) {
      inputFormatters = [
        NumberTextInputFormatter(
          integerDigits: 10,
          decimalDigits: 0,
          groupDigits: 3,
        )
      ];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: keyboardType,
          controller: controller,
          inputFormatters: inputFormatters,
          // onTap: onTap,
          focusNode: focusNode,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none),
              hintText: hintText,
              filled: true,
              fillColor: Color(0xffE6E6E6)),
        ),
      ],
    );
  }

  Future fetchLoginType() async {}
}
