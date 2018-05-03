import 'package:flutter/material.dart';
import 'DateView.dart';
import 'spiessbuch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

void main() => runApp(new MaterialApp(home: new HomePage()));

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  
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
              icon: new Icon(Icons.do_not_disturb), onPressed: _pushSaved),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today), title: new Text("Termine")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.book), title: new Text("Spießbuch")),
        ],
        fixedColor: Colors.red,
        onTap: navigationTapped,
        currentIndex: _page,
      ),
      body: new PageView(
        children: <Widget>[new CalendarView(), new BookView()],
        controller: pageController,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
      ),
    );
  }

  void _pushSaved() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LoginPage.tag);
  }

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() {
      this._page = page;
    });
  }
}
