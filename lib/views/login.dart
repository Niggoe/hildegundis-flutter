import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hildegundis_app/views/homescreen.dart';
import 'package:hildegundis_app/auth.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements AuthStateListener {
  final formKey = new GlobalKey<FormState>();
  BuildContext _ctx;
  String _email;
  String _password;

  _LoginPageState() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        print("Signed in: ${user.uid}");
        var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_IN);
        Navigator.of(_ctx).pushReplacementNamed(HomePage.tag);
      } catch (e) {
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Hildegundis APP"),
      ),
      body: new Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: new Form(
              key: formKey,
              child: new ListView(
                children: buildInputs(),
                scrollDirection: Axis.vertical,
              ))),
    );
  }

  List<Widget> buildInputs() {
    return [
      SizedBox(
        height: 12.0,
      ),
      new Row(
        children: [
          new Expanded(
              child: SizedBox(
            height: 12.0,
          )),
          new Expanded(
              child: new CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: new AssetImage('assets/AppLogo.png'),
            radius: 50.0,
          )),
          new Expanded(
              child: SizedBox(
            height: 12.0,
          )),
        ],
      ),
      SizedBox(
        height: 12.0
      ),
      new TextFormField(
        decoration: new InputDecoration(
            labelText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 8.0),
      new TextFormField(
        decoration: new InputDecoration(
            labelText: 'Passwort',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
      SizedBox(height: 8.0),
      new Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: validateAndSubmit,
            color: Colors.indigoAccent,
            child: Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      new Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.redAccent.shade100,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: handleLoginWithoutCredentials,
            color: Colors.redAccent,
            child: Text('Ohne Login weiter', style: TextStyle(color: Colors.white)),
          ),
        ),
      )
    ];
  }

  void handleLoginWithoutCredentials() {
    Navigator.of(_ctx).pushReplacementNamed(HomePage.tag);
  }

  @override
  void onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(_ctx).pushReplacementNamed(HomePage.tag);
    }
  }
}
