import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'event.dart';
import 'addEventDialog.dart';
import 'eventService.dart';

class CalendarView extends StatefulWidget {
  CalendarViewState createState() => new CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  List<Event> data = new List();
  EventService eventService = new EventService();

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
    });

    return "Success";
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }

  Widget buildRow(Event data, int index) {
    var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    var dateString = formatter.format(data.timepoint);

    return new ListTile(
      title: new Text(data.title),
      subtitle: new Text(
          dateString + " Uhr\n\n" + data.location + " - " + data.clothes + "\n\n"),
      leading: new Icon(Icons.event),
      onLongPress: () => handleLongPress(data, index),
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
        body: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, index) {
              if (index < data.length) return buildRow(data[index], index);
            }));
  }

  Future addEventPressed() async {
    Event addedEvent =
        await Navigator.of(context).push(new MaterialPageRoute<Event>(
            builder: (BuildContext context) {
              return new AddEvent();
            },
            fullscreenDialog: true));
    eventService.createEvent(addedEvent);
    setState(() {
      data.add(addedEvent);
    });
  }

  handleLongPress(Event eventToDelete, int index) {
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
}
