import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homescreen.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

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
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print("Signed in: ${user.uid}");
          Navigator.of(context).pushReplacementNamed(HomePage.tag);
        } else {
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);
          print("Registered user ${user.uid}");
        }
      } catch (e) {
        print("Error $e");
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Hildegundis APP"),
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildInputs() + buildSubmitButtons(),
              ))),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Passwort'),
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: new Text(
            'Login',
            style: new TextStyle(fontSize: 20.0),
          ),
        ),
        new FlatButton(
          child: new Text(
            'Create an account ',
            style: new TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: new Text(
            'Register',
            style: new TextStyle(fontSize: 20.0),
          ),
        ),
        new FlatButton(
          child: new Text(
            'Have an Account? Login',
            style: new TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
