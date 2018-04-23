import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import "package:intl/intl.dart";
import "package:intl/date_symbol_data_local.dart";

void main() => runApp(new MaterialApp(home: new HomePage()));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List data;
  Future germanDatesFuture;

  Future<String> fetchPost() async {
    var response = await http.get("https://www.hildegundisapp.de/dates");

    this.setState(() {
      Map<String, dynamic> user = json.decode(response.body);
      data = user["result"];
    });

    return "Success";
  }

  @override
  void initState() {
    print("hier bin ich");
    this.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Termine Hildegundis"),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
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
              print(index);
              if (index.isOdd) return new Divider();
              final i = index ~/ 2;
              print(i);
              if (i < data.length) return buildRow(data[i]);
            }));
  }

  void _pushSaved() {}

  void addEventPressed() {
    
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
}
