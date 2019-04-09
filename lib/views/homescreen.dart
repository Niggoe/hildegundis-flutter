import 'package:flutter/material.dart';
import 'package:hildegundis_app/views/FirebaseViewTransactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hildegundis_app/views/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hildegundis_app/ui/EventsUI.dart';
import 'package:hildegundis_app/views/FormationView.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  final GoogleSignIn _gSignIn = new GoogleSignIn();

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GHvM"),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.texture),
              tooltip: "Show impressum",
              onPressed: showimpressum),
          new IconButton(
            icon: new Icon(Icons.do_not_disturb),
            onPressed: loggedOutPressed,
            tooltip: "Logout",
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today), title: new Text("Termine")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.book), title: new Text("Spießbuch")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.face), title: new Text("Aufstellung"))
        ],
        fixedColor: Colors.red,
        onTap: navigationTapped,
        currentIndex: _page,
      ),
      body: new PageView(
        children: <Widget>[
          new EventsUI(),
          new FirebaseViewStrafes(),
          new FormationView()
        ],
        controller: pageController,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
      ),
    );
  }

  void loggedOutPressed() {
    _gSignIn.signOut();
    FirebaseAuth.instance
        .signOut()
        .then((_) => Navigator.of(context).pushReplacementNamed(LoginPage.tag));
  }

  void showimpressum() async {
    const url = "http://nigromarmedia.de/index.php/impressum/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() {
      this._page = page;
    });
  }
}
