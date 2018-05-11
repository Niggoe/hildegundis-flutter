import 'package:flutter/material.dart';
import 'package:hildegundis_app/views/login.dart';
import 'package:hildegundis_app/views/homescreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage()
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login Page',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: routes,
      home: LoginPage(),
    );
  }
}
