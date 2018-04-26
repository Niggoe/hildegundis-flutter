import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addStrafeDialog.dart';
import 'strafe.dart';

class BookView extends StatefulWidget {
  BookViewState createState() => new BookViewState();
}

const allowedUsers = ["tSFXWNgYNRhzFKXKw3xvaEhCsUB2"];

class BookViewState extends State<BookView> {
  List<Strafe> data = new List();
  Map<String, List<Strafe>> perNameMap = new Map();

  Future<String> fetchPost() async {
    var response = await http.get("https://www.hildegundisapp.de/accountings");

    Map<String, dynamic> user = json.decode(response.body);
    List<Strafe> allStrafen = createListFromStrafen(user);
    this.setState(() {
      data = allStrafen;
    });
    return "Success";
  }

  List<Strafe> createListFromStrafen(Map<String, dynamic> user) {
    List<Strafe> returnList = new List();
    List values = new List();
    values = user["result"];
    print(values);
    for (int i = 0; i < values.length; i++) {
      Strafe currentStrafe = new Strafe();
      currentStrafe.date = values[i]["date"] == '' ? null : DateTime.parse(values[i]["date"]);
      currentStrafe.name = values[i]['name'];
      currentStrafe.grund = values[i]["grund"];
      int betragString = values[i]["betrag"];
      currentStrafe.betrag = betragString.toDouble();
      returnList.add(currentStrafe);
    }
    return returnList;
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }

  Widget buildRow(Strafe strafe) {
    //var parsedDate = DateTime.parse(date);
    //var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    //var dateString = formatter.format(parsedDate);

    return new ListTile(
      title: new Text(strafe.name),
      subtitle: new Text(strafe.date.toString() +
          "\n\n Grund: " +
          strafe.grund +
          " - Betrag: " +
          strafe.betrag.toString()),
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
      Strafe addedStrafe =
          await Navigator.of(context).push(new MaterialPageRoute<Strafe>(
              builder: (BuildContext context) {
                return new DialogAddStrafe();
              },
              fullscreenDialog: true));
      setState(() {
        data.add(addedStrafe);
      });
    }
  }
}
