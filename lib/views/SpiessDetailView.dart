import 'package:flutter/material.dart';
import 'package:hildegundis_app/models/strafe.dart';
import 'package:intl/intl.dart';
import 'package:hildegundis_app/services/StrafeService.dart';

class DetailPageStrafe extends StatefulWidget {
  @override
  _State createState() => new _State();
  final List<Strafe> strafenPerName;
  final String nameStrafen;

  DetailPageStrafe({Key key, this.strafenPerName, this.nameStrafen})
      : super(key: key);
}

class _State extends State<DetailPageStrafe> {
  var formatter = new DateFormat("dd.MM.yyyy");
  StrafeService strafeService = new StrafeService();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Strafen ${widget.nameStrafen}"),
          backgroundColor: Colors.indigo,
        ),
        body: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, index) {
              if (index < widget.strafenPerName.length)
                return buildRow(widget.strafenPerName[index], index);
            }));
  }

  Widget buildRow(Strafe strafe, int index) {
    //var parsedDate = DateTime.parse(date);
    //var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    //var dateString = formatter.format(parsedDate);
    return new Column(
      children: <Widget>[
        new ListTile(
          key: new Key(strafe.id.toString()),
          title: new Text(formatter.format(strafe.date)),
          subtitle: new Text("Grund: " +
              strafe.grund +
              "\nBetrag: " +
              strafe.betrag.toString() +
              "€"),
          leading: new Icon(Icons.monetization_on),
        ),
        new Divider(
          color: Colors.black,
        )
      ],
    );
  }
}
