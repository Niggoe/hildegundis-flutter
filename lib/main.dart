import 'package:flutter/material.dart';
import "package:intl/date_symbol_data_local.dart";
import 'DateView.dart';
import 'spiessbuch.dart';

void main() => runApp(new MaterialApp(home: new HomePage()));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hildegundis APP"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
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
      body: new TabBarView(
        children: <Widget>[new CalendarView(), new BookView()],
        controller: tabController,
      ),
    );
  }

  void _pushSaved() {}

  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    print("Switch to tab " + page.toString());
    //_pageController.animateToPage(page,
    //  duration: const Duration(milliseconds: 300), curve: Curves.ease);
    tabController.animateTo(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() {
      this._page = page;
    });
  }
}



