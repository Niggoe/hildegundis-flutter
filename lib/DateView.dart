import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import "package:intl/intl.dart";
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  CalendarViewState createState() => new CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  List data = new List();

  Future<String> fetchPost() async {
    var response = await http.get("https://www.hildegundisapp.de/dates");

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
    var parsedDate = DateTime.parse(data["startdate"]);
    var formatter = new DateFormat("dd.MM.yyyy H:m");
    var dateString = formatter.format(parsedDate);

    return new ListTile(
      title: new Text(data["name"]),
      subtitle: new Text(
          dateString + "\n\n" + data["location"] + " - " + data["clothes"]),
      leading: new Icon(Icons.event),
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
              if (index.isOdd) return new Divider();
              final i = index ~/ 2;

              if (i < data.length) return buildRow(data[i]);
            }));
  }

  void addEventPressed() {}
}
