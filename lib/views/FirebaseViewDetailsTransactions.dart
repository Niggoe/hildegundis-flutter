import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/models/strafe.dart';
import "package:intl/intl.dart";
import "package:hildegundis_app/constants.dart";
import "dart:async";

class FirebaseViewDetailsTransactions extends StatefulWidget {
  static String tag = "firebase-detail-view-transactions";
  final String name;
  final List<Strafe> strafePerName;
  final double amount;

  FirebaseViewDetailsTransactions(
      {Key key, this.name, this.amount, this.strafePerName})
      : super(key: key);

  FirebaseViewDetailsTransactionsState createState() =>
      new FirebaseViewDetailsTransactionsState();
}

const allowedUsers = [
  "tSFXWNgYNRhzFKXKw3xvaEhCsUB2",
  "q34qmsOSzWWR30I06omGJ3ti0142",
  "v8qunIYGqhNnGPUdykHqFs2ABYW2"
];

class FirebaseViewDetailsTransactionsState
    extends State<FirebaseViewDetailsTransactions> {


  Widget _makeCard(BuildContext context, Strafe strafe) {
    return new Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.red,
      child: Container(
        decoration: BoxDecoration(
            color: ProjectConfig.BoxDecorationColorDateOverview,
            borderRadius: new BorderRadius.all(const Radius.circular(15.0))),
        child: _buildListItem(context, strafe),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Strafe currentStrafe) {
    var formatter = new DateFormat("dd.MM.yyyy");
    var date = currentStrafe.date;
    var datestring = formatter.format(date);

    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      key: new ValueKey(currentStrafe.date),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(
                    width: 1.0, color: ProjectConfig.FontColorDateOverview))),
        child: Icon(Icons.calendar_today,
            color: ProjectConfig.IconColorDateOverviewLeading),
      ),
      title: new Text(
        currentStrafe.name,
        style: TextStyle(
            color: ProjectConfig.FontColorDateOverview,
            fontWeight: FontWeight.bold),
      ),
      subtitle: new Column(children: <Widget>[
        new Row(
          children: <Widget>[
            Icon(Icons.linear_scale,
                color: ProjectConfig.IconColorDateOverview),
            Text(datestring,
                style: TextStyle(color: ProjectConfig.FontColorDateOverview))
          ],
        ),
        new Text(currentStrafe.grund,
            style: TextStyle(color: ProjectConfig.IconColorDateOverview))
      ]),
      //onLongPress: () => handleLongPress(document),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Column(
          children: <Widget>[
            new Text(widget.name),
            new Text(
              "Summe " + widget.amount.toString(),
              style: new TextStyle(
                  fontSize: ProjectConfig.FontSizeSubHeaderDateDetail),
            )
          ],
        ),
        backgroundColor: Colors.indigo,
        actions: <Widget>[],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          // addEventPressed();
        },
        child: new Icon(Icons.add),
        tooltip: ProjectConfig.TextFloatingActionButtonTooltipDateOverview,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var keys = widget.strafePerName;
    return new ListView.builder(
        itemCount: widget.strafePerName.length,
        itemBuilder: (BuildContext context, index) {
          if (index < keys.length)
            return _makeCard(context, keys[index]);
          //if (index < data.length) return buildRow(data[index], index);
        });
  }
}
