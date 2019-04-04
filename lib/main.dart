import 'package:flutter/material.dart';
import 'package:hildegundis_app/views/login.dart';
import 'package:hildegundis_app/views/homescreen.dart';
import 'package:hildegundis_app/views/FirebaseViewDates.dart';
import 'package:hildegundis_app/views/FirebaseViewTransactions.dart';
import "loginUtil.dart";

void main() async {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    FirebaseViewDate.tag: (context) => FirebaseViewDate(),
    FirebaseViewTransactions.tag: (context) => FirebaseViewTransactions()
  };

  Widget _defaultHome = new LoginPage();
  bool result = await userIsLoggedIn();
  if (result) {
    _defaultHome = new HomePage();
  }

  runApp(new MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: routes,
      home: _defaultHome));
}
