import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addStrafeDialog.dart';

class BookView extends StatefulWidget {
  BookViewState createState() => new BookViewState();
}

const allowedUsers = ["tSFXWNgYNRhzFKXKw3xvaEhCsUB2"];

class BookViewState extends State<BookView> {
  List data = new List();
  List _items = [];

  Future<String> fetchPost() async {
    var response = await http.get("https://www.hildegundisapp.de/accountings");

    this.setState(() {
      Map<String, dynamic> user = json.decode(response.body);
      data = user["result"];
    });

    return "Success";
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }

  Widget buildRow(data) {
    var date = data["date"];

    //var parsedDate = DateTime.parse(date);
    //var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    //var dateString = formatter.format(parsedDate);

    return new ListTile(
      title: new Text(data["name"]),
      subtitle: new Text(date +
          "\n\n Grund: " +
          data["grund"] +
          " - Betrag: " +
          data["betrag"].toString()),
      leading: new Icon(Icons.monetization_on),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            addEventPressed();
          },
          tooltip: "Termin hinzufügen",
          child: new Icon(Icons.add),
        ),
        body: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, index) {
              if (index.isOdd) return new Divider();
              final i = index ~/ 2;

              if (i < data.length) return buildRow(data[i]);
            }));
  }

  Future addEventPressed() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var user_id = user.uid;
    print("User: ${user.uid} wants to read");
    if (!allowedUsers.contains(user_id)) {
      final snackBar = new SnackBar(
        content: new Text("Leider darfst du keine Strafen hinzufügen"),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      ModelData data =
          await Navigator.of(context).push(new MaterialPageRoute<ModelData>(
              builder: (BuildContext context) {
                return new DialogAddStrafe();
              },
              fullscreenDialog: true));
      setState(() {
        _items.add(data);
      });
    }
  }
}
