import 'package:flutter/material.dart';
import 'package:hildegundis_app/ui/FineUI.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hildegundis_app/ui/EventsUI.dart';
import 'package:hildegundis_app/ui/FormationUI.dart';
import 'package:hildegundis_app/ui/LoginUI.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hildegundis_app/blocs/FineScreenBlocProvider.dart';
import 'package:hildegundis_app/blocs/BottomNavBarBloc.dart';
import 'package:hildegundis_app/blocs/EventScreenBlocProvider.dart';
import 'package:hildegundis_app/blocs/FormationUIBlocProvider.dart';
import 'package:hildegundis_app/ui/ShowSongbookUI.dart';

class HomePageUI extends StatefulWidget {
  static String tag = 'home-page';

  @override
  HomePageUIState createState() => new HomePageUIState();
}

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

class HomePageUIState extends State<HomePageUI> {
  int _page = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
    var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = new RemoteNotification();
      AndroidNotification android = message.notification?.android;
      print("Foreground: $message");
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                "channelID", "ChannelName", "channelDescription",
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened App: $message");
    });

    FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.instance.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        alert: true,
        badge: true,
        sound: true);
  }

  @override
  void dispose() {
    super.dispose();
    _bottomNavBarBloc.close();
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
              case NavBarItem.SONGBOOK:
                return SongbookUI();
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
              type: BottomNavigationBarType.shifting,
              currentIndex: snapshot.data.index,
              items: [
                new BottomNavigationBarItem(
                    activeIcon:
                        new Icon(Icons.calendar_today, color: Colors.red),
                    icon: new Icon(Icons.calendar_today, color: Colors.indigo),
                    title: new Text(
                      "Termine",
                      style: TextStyle(color: Colors.red),
                    )),
                new BottomNavigationBarItem(
                    activeIcon: new Icon(Icons.book, color: Colors.red),
                    icon: new Icon(Icons.book, color: Colors.indigo),
                    title: new Text(
                      "Spießbuch",
                      style: TextStyle(color: Colors.red),
                    )),
                new BottomNavigationBarItem(
                    activeIcon: new Icon(Icons.face, color: Colors.red),
                    icon: new Icon(
                      Icons.face,
                      color: Colors.indigo,
                    ),
                    title: new Text(
                      "Aufstellung",
                      style: TextStyle(color: Colors.red),
                    )),
                new BottomNavigationBarItem(
                    activeIcon: new Icon(Icons.music_note, color: Colors.red),
                    icon: new Icon(
                      Icons.music_note,
                      color: Colors.indigo,
                    ),
                    title: new Text(
                      "Liederbuch",
                      style: TextStyle(color: Colors.red),
                    ))
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
