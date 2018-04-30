import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'addStrafeDialog.dart';
import 'strafe.dart';
import 'StrafeService.dart';

class BookView extends StatefulWidget {
  BookViewState createState() => new BookViewState();
}

const allowedUsers = ["tSFXWNgYNRhzFKXKw3xvaEhCsUB2"];

class BookViewState extends State<BookView> {
  List<Strafe> data = new List();
  Map<String, List<Strafe>> perNameMap = new Map();
  StrafeService strafeService = new StrafeService();
  var formatter = new DateFormat("dd.MM.yyyy");

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
    Map<String, List<Strafe>> mapPerName = new Map();
    List values = new List();
    values = user["result"];
    for (int i = 0; i < values.length; i++) {
      Strafe currentStrafe = new Strafe();
      currentStrafe.date =
          values[i]["date"] == '' ? null : DateTime.parse(values[i]["date"]);
      currentStrafe.name = values[i]['name'];
      currentStrafe.grund = values[i]["grund"];
      currentStrafe.id = values[i]["key"];
      if (values[i]["betrag"].runtimeType == int) {
        currentStrafe.betrag = values[i]["betrag"].toDouble();
      } else {
        currentStrafe.betrag = values[i]["betrag"];
      }
      if (perNameMap.containsKey(currentStrafe.name)) {
        perNameMap[currentStrafe.name].add(currentStrafe);
      } else {
        List<Strafe> userStrafe = new List();
        userStrafe.add(currentStrafe);
        perNameMap[currentStrafe.name] = userStrafe;
      }
      this.setState(() {
        perNameMap = mapPerName;
      });
      returnList.add(currentStrafe);
    }
    return returnList;
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }


  Widget buildRow(Strafe strafe, int index) {
    //var parsedDate = DateTime.parse(date);
    //var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    //var dateString = formatter.format(parsedDate);
    return new Dismissible(
        key: new Key(strafe.id.toString()),
        background: new Container(
          color: Colors.red,
          child: new Icon(Icons.delete),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          handleDismissedSwipe(direction, strafe, index);
        },
        child: new ListTile(
          title: new Text(strafe.name),
          subtitle: new Text(formatter.format(strafe.date) +
              "\n\n Grund: " +
              strafe.grund +
              " - Betrag: " +
              strafe.betrag.toString() +
              "€\n"),
          leading: new Icon(Icons.monetization_on),
        ));
  }

  handleUndo(Strafe strafe, int index, StrafeService strafService) {
    strafService.createStrafe(strafe);
    this.setState(() {
      data.insert(index, strafe);
    });
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
              if (index < data.length) return buildRow(data[index], index);
            }));
  }

  Future addEventPressed() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        final snackBar = new SnackBar(
          content: new Text("Leider darfst du keine Strafen hinzufügen"),
          backgroundColor: Colors.red,
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
    } else {
      final snackBar = new SnackBar(
        content: new Text("Bitte erst einloggen"),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void handleDismissedSwipe(direction, Strafe strafe, int index) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    if (user != null) {
      if (allowedUsers.contains(user.uid)) {
        strafeService.deleteStrafe(strafe);
      }
    }
    this.setState(() {
      data.removeAt(index);
    });

    Scaffold.of(context).showSnackBar(new SnackBar(
        action: new SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            handleUndo(Strafe.from(strafe), index, strafeService);
          },
        ),
        content:
            new Text("Item gelöscht für ${strafe.name} Grund: ${strafe.grund}"),
        backgroundColor: Colors.lightGreen));
  }
}
