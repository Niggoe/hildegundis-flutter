import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:hildegundis_app/models/event.dart';
import 'package:hildegundis_app/dialogs/addEventDialog.dart';
import 'package:hildegundis_app/services/eventService.dart';

class CalendarView extends StatefulWidget {
  CalendarViewState createState() => new CalendarViewState();
}

const allowedUsers = ["tSFXWNgYNRhzFKXKw3xvaEhCsUB2", "q34qmsOSzWWR30I06omGJ3ti0142", "v8qunIYGqhNnGPUdykHqFs2ABYW2"];

class CalendarViewState extends State<CalendarView> {
  List<Event> data = new List();
  EventService eventService = new EventService();
  bool _loadingInProgress;

  Future<String> fetchPost() async {
    var response = await http.get("https://www.hildegundisapp.de/dates");
    Map<String, dynamic> user = json.decode(response.body);

    List<Event> finalEvents = new List();
    List values = new List();
    values = user["result"];

    for (int i = 0; i < values.length; i++) {
      Event currentEvent = new Event();
      currentEvent.title = values[i]["name"];
      currentEvent.location = values[i]["location"];
      currentEvent.timepoint = values[i]["startdate"] == ''
          ? null
          : DateTime.parse(values[i]["startdate"]);
      currentEvent.clothes = values[i]["clothes"];
      currentEvent.id = values[i]["id"];
      finalEvents.add(currentEvent);
    }

    this.setState(() {
      data.addAll(finalEvents);
      _loadingInProgress = false;
    });

    return "Success";
  }

  void initState() {
    super.initState();
    _loadingInProgress = true;
    this.fetchPost();
  }

  Widget buildRow(Event data, int index) {
    var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    var dateString;
    if (data != null) {
      dateString = formatter.format(data.timepoint);
      return new ListTile(
        title: new Text(data.title),
        subtitle: new Text(dateString +
            " Uhr\n\n" +
            data.location +
            " - " +
            data.clothes +
            "\n\n"),
        leading: new Icon(Icons.event),
        onLongPress: () => handleLongPress(data, index),
      );
    }
    return null;
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
    if (_loadingInProgress) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: data.length,
          itemBuilder: (BuildContext context, index) {
            if (index < data.length) return buildRow(data[index], index);
          });
    }
  }

  Future addEventPressed() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        final snackBar = new SnackBar(
          content: new Text("Leider darfst du keine Termine hinzufügen"),
          backgroundColor: Colors.red,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        Event addedEvent =
            await Navigator.of(context).push(new MaterialPageRoute<Event>(
                builder: (BuildContext context) {
                  return new AddEvent();
                },
                fullscreenDialog: true));
        if (addedEvent != null) {
          eventService.createEvent(addedEvent);
          setState(() {
            data.add(addedEvent);
          });
        }
      }
    } else {
      final snackBar = new SnackBar(
        content: new Text("Bitte erst einloggen"),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future handleLongPress(Event eventToDelete, int index) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        final snackBar = new SnackBar(
          content: new Text("Leider darfst du keine Termine löschen"),
          backgroundColor: Colors.red,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: new Text("Termin löschen?"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        eventService.deleteEvent(eventToDelete);
                        this.setState(() {
                          data.removeAt(index);
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
