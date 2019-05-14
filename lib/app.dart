import 'package:flutter/material.dart';
import 'package:hildegundis_app/ui/LoginUI.dart';
import 'package:hildegundis_app/blocs/LoginBlocProvider.dart';
import 'package:hildegundis_app/ui/HomeUI.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
        child: MaterialApp(
      theme: ThemeData(accentColor: Colors.blue, primaryColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Gesellschaft Hildegundis von Meer 2016",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          elevation: 0.0,
        ),
        body: LoginScreen(),
      ),
      routes: {
        HomePageUI.tag: (context) => HomePageUI(),
        LoginScreen.tag: (context) => LoginScreen()
      },
    ));
    /* return MaterialApp(
        theme: ThemeData(accentColor: Colors.blue, primaryColor: Colors.green),
        home: LoginScreen()); */
  }
}
