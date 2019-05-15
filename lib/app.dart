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
