import 'package:flutter/material.dart';
import 'package:hildegundis_app/services/StrafeService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/constants.dart';

class DetailPageDate extends StatefulWidget {
  @override
  _State createState() => new _State();
  final DocumentSnapshot snapshot;
  DetailPageDate({Key key, this.snapshot}) : super(key: key);
}

class _State extends State<DetailPageDate> {
  StrafeService strafeService = new StrafeService();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(ProjectConfig.TextAppBarDateDetail),
          backgroundColor: ProjectConfig.ColorAppBar,
        ),
        body: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 1,
            itemBuilder: (BuildContext context, index) {
              return buildRow();
            }));
  }

  Widget buildRow() {
    var formatter = ProjectConfig.dateDetailFormat;
    return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(const Radius.circular(15.0))),
        child: new Column(children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                widget.snapshot['name'],
                style: TextStyle(
                    color: ProjectConfig.FontColorDateDetail,
                    fontSize: ProjectConfig.FontSizeHeaderDateDetail,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Text(formatter.format(widget.snapshot['date']) + " Uhr",
                  style: TextStyle(color: ProjectConfig.FontColorDateDetail, fontSize: ProjectConfig.FontSizeSubHeaderDateDetail))
            ],
          ),
          new Row(
            children: <Widget>[
              new Text(widget.snapshot['location'],
                  style: TextStyle(color: ProjectConfig.FontColorDateDetail, fontSize: ProjectConfig.FontSizeSubHeaderDateDetail))
            ],
          ),
          new Row(
            children: <Widget>[
              new Text(widget.snapshot['clothes'],
                  style: TextStyle(color: ProjectConfig.FontColorDateDetail, fontSize: ProjectConfig.FontSizeSubHeaderDateDetail))
            ],
          ),
        ]),
      ),
    );
  }
}
