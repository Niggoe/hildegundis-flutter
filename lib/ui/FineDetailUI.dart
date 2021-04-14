import 'package:flutter/material.dart';
import 'package:hildegundis_app/models/Fine.dart';
import "package:intl/intl.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:hildegundis_app/constants.dart";
import "package:hildegundis_app/blocs/FineScreenBloc.dart";
import "package:hildegundis_app/blocs/FineScreenBlocProvider.dart";

class FineDetailUI extends StatefulWidget {
  static String tag = "firebase-detail-view-Strafes";
  final String name;

  FineDetailUI({Key key, this.name}) : super(key: key);

  FineDetailUIState createState() => new FineDetailUIState();
}

const allowedUsers = [
  "tSFXWNgYNRhzFKXKw3xvaEhCsUB2",
  "q34qmsOSzWWR30I06omGJ3ti0142",
  "v8qunIYGqhNnGPUdykHqFs2ABYW2"
];

class FineDetailUIState extends State<FineDetailUI> {
  FineScreenBloc _bloc;

  Widget _makeCard(BuildContext context, DocumentSnapshot document) {
    Fine currentStrafe = new Fine();
    currentStrafe.date = document["date"] == '' ? null : document["date"];
    currentStrafe.name = document['name'];
    currentStrafe.reason = document["reason"];
    currentStrafe.payed = document["payed"];
    if (document["amount"].runtimeType == int) {
      currentStrafe.amount = document["amount"].toDouble();
    } else {
      currentStrafe.amount = document["amount"];
    }
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
        child: _buildListItem(context, currentStrafe),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Fine currentStrafe) {
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
                style: TextStyle(color: ProjectConfig.FontColorDateOverview)),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            ),
            Text(
              currentStrafe.amount.toString() + "€",
              style: TextStyle(color: ProjectConfig.FontColorDateOverview),
            )
          ],
        ),
        new Text(currentStrafe.reason,
            style: TextStyle(color: ProjectConfig.IconColorDateOverview))
      ]),
      trailing: Icon(currentStrafe.payed ? Icons.attach_money : Icons.money_off,
          color: (currentStrafe.payed ? Colors.green[500] : Colors.red[500])),
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
    return new StreamBuilder(
      stream: _bloc.getAllFinesForName(widget.name),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, index) {
              return _makeCard(context, snapshot.data.documents[index]);
              //if (index < data.length) return buildRow(data[index], index);
            });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = FineScreenBlocProvider.of(context);
  }
}
