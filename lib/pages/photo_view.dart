import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/prescription_create.dart';
import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/LoginResponseData.dart';
import 'profile_page.dart';

class NewRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewRequestState();
  }
}

class _NewRequestState extends State<NewRequest> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  final reasonController = TextEditingController();


  hitLogin() async {
    var client = new Client();

    final prefs = await SharedPreferences.getInstance();

    final String? loginData = prefs.getString('loginData');

    final toJson = json.decode(loginData!);

    LoginResponseData data =
    LoginResponseData.fromJson(toJson as Map<String, dynamic>);

    if (reasonController.text.isNotEmpty) {
      Map<String, String> body = {
        'patient_id': data.data.userDetails.dId,
        'api_type': 'patientRequest',
        'reason': reasonController.text.toString(),
      };
      print(body);
      Response response = await post(
        Uri.parse("http://sangeethajewelry.in/raguman/news/api.php"),
        body: body,
      );
      print(response.body);

      if (response.statusCode == 200) {
        final toJson = json.decode(response.body);
        Navigator.pop(context);

        Fluttertoast.showToast(
            msg: "Your request has been given!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please write reason!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "New Request ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: HexColor('#FFC867'),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  "Reason",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    child: TextField(
                                      controller: reasonController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Tell the reason to doctor',
                                        contentPadding: EdgeInsets.all(20.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                          ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(50, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent),
                              shadowColor: MaterialStateProperty.all(
                                  Colors.transparent),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Request".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              hitLogin();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
