import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:hildegundis_app/dialogs/addStrafeDialog.dart';
import 'package:hildegundis_app/models/strafe.dart';
import 'package:hildegundis_app/services/StrafeService.dart';
import 'SpiessDetailView.dart';

class BookView extends StatefulWidget {
  BookViewState createState() => new BookViewState();
}

const allowedUsers = ["tSFXWNgYNRhzFKXKw3xvaEhCsUB2"];

class BookViewState extends State<BookView> {
  List<Strafe> data = new List();
  Map<String, List<Strafe>> perNameMap = new Map();
  StrafeService strafeService = new StrafeService();
  var formatter = new DateFormat("dd.MM.yyyy");
  bool _loadingData;

  Future<String> fetchPost() async {
    var response = await http.get("https://www.hildegundisapp.de/accountings");

    Map<String, dynamic> user = json.decode(response.body);
    Map<String, List<Strafe>> fetchedNameMap = createListFromStrafen(user);
    this.setState(() {
      perNameMap = fetchedNameMap;
      _loadingData = false;
    });
    return "Success";
  }

  Map<String, List<Strafe>> createListFromStrafen(Map<String, dynamic> user) {
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
      if (mapPerName.containsKey(currentStrafe.name)) {
        mapPerName[currentStrafe.name].add(currentStrafe);
      } else {
        List<Strafe> userStrafe = new List();
        userStrafe.add(currentStrafe);
        mapPerName[currentStrafe.name] = userStrafe;
      }
    }
    return mapPerName;
  }

  void initState() {
    _loadingData = true;
    super.initState();
    this.fetchPost();
  }

  Widget buildRowTotal(List<Strafe> strafePerName, int index, String name) {
    double wholeBetrag = 0.0;

    for (Strafe straf in strafePerName) {
      wholeBetrag += straf.betrag;
    }

    return new ListTile(
      key: new Key(name),
      title: new Text(name),
      subtitle: new Text(wholeBetrag.toString() + "€"),
      leading: new Icon(Icons.face),
      onTap: () {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new DetailPageStrafe(
              strafenPerName: strafePerName, nameStrafen: name),
        );
        Navigator.of(context).push(route);
      },
      onLongPress: () => handleLongPress(strafePerName, name),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            addEventPressed();
          },
          tooltip: "Termin hinzufügen",
          child: new Icon(Icons.add),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (_loadingData) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      var keys = perNameMap.keys.toList();
      return new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, index) {
            if (index < keys.length)
              return buildRowTotal(perNameMap[keys[index]], index, keys[index]);
            //if (index < data.length) return buildRow(data[index], index);
          });
    }
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
          if (!perNameMap.containsKey(addedStrafe.name)) {
            perNameMap[addedStrafe.name] = new List();
          }
          perNameMap[addedStrafe.name].add(addedStrafe);
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

  Future handleLongPress(List<Strafe> listForName, String name) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        final snackBar = new SnackBar(
          content: new Text("Leider darfst du keine Strafen löschen"),
          backgroundColor: Colors.red,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: new Text("Alle Strafen löschen?"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        strafeService.deleteStrafeList(listForName);
                        this.setState(() {
                          perNameMap.remove(name);
                        });
                        Navigator.pop(context);
                      },
                      child: new Text("OK")),
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Text("Abbruch"))
                ],
              );
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
}
