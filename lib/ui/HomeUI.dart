import 'package:flutter/material.dart';
import 'package:hildegundis_app/ui/FineUI.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hildegundis_app/ui/EventsUI.dart';
import 'package:hildegundis_app/ui/FormationUI.dart';
import 'package:hildegundis_app/ui/LoginUI.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hildegundis_app/blocs/FineScreenBlocProvider.dart';
import 'package:hildegundis_app/blocs/BottomNavBarBloc.dart';
import 'package:hildegundis_app/blocs/EventScreenBlocProvider.dart';
import 'package:hildegundis_app/blocs/FormationUIBlocProvider.dart';

class HomePageUI extends StatefulWidget {
  static String tag = 'home-page';

  @override
  HomePageUIState createState() => new HomePageUIState();
}

class HomePageUIState extends State<HomePageUI> {
  int _page = 0;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
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

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registred: $settings');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bottomNavBarBloc.close();
  }

  showMessage(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
        "channelID", "ChannelName", "channelDescription");
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
        0, "$message.title", "$message.body", platform);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("GHvM"),
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.info_outline),
                tooltip: "Show impressum",
                onPressed: showimpressum),
            new IconButton(
              icon: new Icon(Icons.do_not_disturb),
              onPressed: loggedOutPressed,
              tooltip: "Logout",
            ),
          ],
        ),
        body: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.EVENTS:
                return EventScreenBlocProvider(
                  child: EventsUI(),
                );
              case NavBarItem.FINES:
                return FineScreenBlocProvider(
                  child: FineUI(),
                );
              case NavBarItem.FORMATION:
                return FormationUIBlocProvider(
                  child: FormationUI(),
                );
            }
          },
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            return BottomNavigationBar(
              fixedColor: Colors.red,
              onTap: _bottomNavBarBloc.pickItem,
              currentIndex: snapshot.data.index,
              items: [
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.calendar_today),
                    title: new Text("Termine")),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.book), title: new Text("Spießbuch")),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.face), title: new Text("Aufstellung"))
              ],
            );
          },
        ));
  }

  void loggedOutPressed() {
    _bottomNavBarBloc.logoutUser().then(
        (_) => Navigator.of(context).pushReplacementNamed(LoginScreen.tag));
  }

  void showimpressum() async {
    const url = "http://nigromarmedia.de/index.php/impressum/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
