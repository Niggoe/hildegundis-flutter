import 'package:flutter/material.dart';
import 'SignInForm.dart';

class LoginScreen extends StatelessWidget {
  static String tag = 'login-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Ges. Hildegundis Login"),
            backgroundColor: Colors.indigo),
        body: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: Colors.indigo[50]),
          alignment: Alignment(0.0, 0.0),
          child: SignInForm(),
        ));
  }
}
