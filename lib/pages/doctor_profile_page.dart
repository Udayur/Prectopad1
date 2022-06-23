import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:flutter_login_ui/pages/new_prescription.dart';
import 'package:flutter_login_ui/pages/splash_screen.dart';
import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/LoginResponseData.dart';
import 'forgot_password_page.dart';
import 'forgot_password_verification_page.dart';
import 'registration_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  final List<String> entries = <String>['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D'];
  final List<int> colorCodes = <int>[600, 500, 100, 600, 500, 600, 500, 100];

  @override
  void initState() {
    super.initState();
    hitLogin();
  }

  hitLogin() async {
    var client = new http.Client();

    final prefs = await SharedPreferences.getInstance();

    final String? loginData = prefs.getString('loginData');
    // final String? loginType = prefs.getString('loginType');

    final toJson = json.decode(loginData!);

    LoginResponseData data =
        LoginResponseData.fromJson(toJson as Map<String, dynamic>);

    Map<String, String> body;
    if (data.data.userDetails.dType == "doctor") {
      body = {
        'patient_id': data.data.userDetails.dId,
        'api_type': 'getDoctorHistory',
      };
    } else {
      body = {
        'patient_id': data.data.userDetails.dId,
        'api_type': 'getPatientHistory',
      };
    }
    print(body);
    Response response = await post(
      Uri.parse("http://sangeethajewelry.in/raguman/news/api.php"),
      body: body,
    );
    print(response.body);

    if (response.statusCode == 200) {
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    // Await the http get response, then decode the json-formatted response.
    // var response = await client.post(url);
    // print(response);
    // if (response.statusCode == 200) {
    //   //After successful login we will redirect to profile page. Let's create profile page now
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    //   var jsonResponse =
    //   jsonDecode(response.body) as Map<String, dynamic>;
    //   var itemCount = jsonResponse['totalItems'];
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Pharm Easy",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                0.0,
                1.0
              ],
                  colors: [
                Theme.of(context).primaryColor.withOpacity(0.2),
                Theme.of(context).accentColor.withOpacity(0.5),
              ])),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "FlutterTutorial.Net",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.screen_lock_landscape_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Splash Screen',
                  style: TextStyle(
                      fontSize: 17, color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SplashScreen(title: "Splash Screen")));
                },
              ),
              ListTile(
                leading: Icon(Icons.login_rounded,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor),
                title: Text(
                  'Login Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.person_add_alt_1,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor),
                title: Text(
                  'Registration Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.password_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Forgot Password Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user_sharp,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Verification Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordVerificationPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            child: HeaderWidget(120, false, Icons.house_rounded),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Patients History",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Card(
                      elevation: 3,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ...ListTile.divideTiles(
                                  color: Colors.grey,
                                  tiles: [
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      leading: Image.asset(
                                        "assets/images/patient.png",
                                        height: 100,
                                      ),
                                      title: Text("Sathish kumar"),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text("12-12-2012"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => NewPrescription()),
              (route) => false);
        },
        backgroundColor: HexColor('#FFC867'),
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
