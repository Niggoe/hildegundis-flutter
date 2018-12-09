import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hildegundis_app/views/homescreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  String _email;
  String _password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void initState() {
    super.initState();
    var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("Foreground: $message");
        showMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print('On launch $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('On resume $message');
      },
    );

    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.getToken().then((token) {
      print("New Token: " + token);
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registred: $settings');
    });
  }

  showMessage(Map<String, dynamic> message) async{
    var android = new AndroidNotificationDetails(
        "channelID", "ChannelName", "channelDescription");
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
        0, "$message.title", "$message.body", platform);
  }

  showMessageTest() async{
        var android = new AndroidNotificationDetails(
        "channelID", "ChannelName", "channelDescription");
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
        0, "Test Notification", "Das ist der Inhalt", platform);
  }

  Future<FirebaseUser> _signIN() async {
    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    print(user);
    return user;
  }

  Future validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        print("Signed in: ${user.uid}");
        Navigator.of(context).pushReplacementNamed(HomePage.tag);
      } catch (e) {
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      SizedBox(height: 12.0),
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
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: validateAndSubmit,
            clipBehavior: Clip.antiAlias,
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
          clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            clipBehavior: Clip.antiAlias,
            onPressed: handleLoginWithoutCredentials,
            color: Colors.redAccent,
            child: Text('Ohne Login weiter',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      new Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.redAccent.shade100,
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            clipBehavior: Clip.antiAlias,
            onPressed: _signIN,
            color: Colors.redAccent,
            child: Text('Mit Google einloggen',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ), new Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.redAccent.shade100,
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            clipBehavior: Clip.antiAlias,
            onPressed: showMessageTest,
            color: Colors.redAccent,
            child: Text('Test notification',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      )
    ];
  }

  void handleLoginWithoutCredentials() {
    Navigator.of(context).pushReplacementNamed(HomePage.tag);
  }
}
