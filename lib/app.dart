import 'package:flutter/material.dart';
import 'package:hildegundis_app/views/login.dart';
import 'package:hildegundis_app/views/homescreen.dart';
import 'package:hildegundis_app/views/FirebaseViewDates.dart';
import 'package:hildegundis_app/views/FirebaseViewTransactions.dart';
import 'blocs/EventScreenBlocProvider.dart';

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    FirebaseViewDate.tag: (context) => FirebaseViewDate(),
    FirebaseViewTransactions.tag: (context) => FirebaseViewTransactions()
  };

  @override
  Widget build(BuildContext context) {
    return EventScreenBlocProvider(
        child: MaterialApp(
            theme:
                ThemeData(accentColor: Colors.blue, primaryColor: Colors.green),
            home: Scaffold(
              
              body: HomePage(),
            )));
  }
}