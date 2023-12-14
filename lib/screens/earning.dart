import 'package:ads/screens/home_page.dart';
import 'package:ads/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ads/services/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'dart:convert';

const storage = FlutterSecureStorage();

class Introduce {
  final String title;
  Introduce(this.title);
}

class EarningPage extends StatefulWidget {
  static const String routeName = "/pages/earning_page";
  String? id;
  EarningPage({Key? key, required this.id}) : super(key: key);
  @override
  _EarningPageState createState() => _EarningPageState(id);
}

class _EarningPageState extends State<EarningPage> {
  String? id;
  _EarningPageState(this.id);
  final titleController = TextEditingController();
  final totalImpressionController = TextEditingController();

  final dateController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  String eCPM = "0";
  @override
  void initState() {
    var now = new DateTime.now();
    final dateNow = now.day.toString() +
        "/" +
        now.month.toString() +
        "/" +
        now.year.toString();
    dateController.text = dateNow;
    super.initState();
    myFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    titleController.dispose();
    dateController.dispose();
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
                            label: "Revenue Earned",
                            hintText: "Eg: 100",
                            keyboardType: TextInputType.number,
                            focusNode: myFocusNode,
                            controller: titleController),
                        SizedBox(
                          height: 20,
                        ),
                        this.TextFieldInput(
                            label: "Total Impression",
                            hintText: "Ex: \50,000",
                            controller: totalImpressionController,
                            keyboardType: TextInputType.number),
                        SizedBox(
                          height: 20,
                        ),
                        this.TextFieldInput(
                          label: "Expected & Date",
                          keyboardType: TextInputType.datetime,
                          controller: dateController,
                          suffixIcon: Icon(Icons.date_range),
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

  saveData() async {
    if (titleController.text == "" ||
        totalImpressionController.text == "" ||
        dateController.text == "") {
      return;
    }
    if (!Utils.isDate(dateController.text, "dd/MM/yyyy")) {
      return;
    }
    var campaignsStr = await storage.read(key: "campaigns");

    final campaigns =
        campaignsStr != null ? jsonDecode(campaignsStr) as List<dynamic> : [];

    final index = campaigns
        .indexWhere((element) => element["id"].toString() == id.toString());

    print(campaigns);
    print(id);

    final currentList = campaigns[index]["list"] as List<dynamic>;

    currentList.add({
      "earned": titleController.text,
      "total_impression": totalImpressionController.text,
      "date": dateController.text
    });
    campaigns[index]["list"] = currentList;
    var campaignsJSON = jsonEncode(campaigns);
    await storage.write(key: "campaigns", value: campaignsJSON);
    GoRouter.of(context)
        .pushNamed("detail-campaign", pathParameters: {"id": id.toString()});
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
      Widget? suffixIcon,
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
          onTap: onTap,
          focusNode: focusNode,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none),
              hintText: hintText,
              filled: true,
              suffixIcon: suffixIcon,
              fillColor: Color(0xffE6E6E6)),
        ),
      ],
    );
  }

  Future fetchLoginType() async {}
}
