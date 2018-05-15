import 'package:flutter/material.dart';
import 'package:hildegundis_app/views/login.dart';
import 'package:hildegundis_app/views/homescreen.dart';
import "loginUtil.dart";

void main() async {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage()
  };

  Widget _defaultHome = new LoginPage();
  bool result = await userIsLoggedIn();
  if (result) {
    _defaultHome = new HomePage();
  }

  runApp(new MaterialApp(
      title: 'Login Page',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: routes,
      home: _defaultHome)
  );
}
