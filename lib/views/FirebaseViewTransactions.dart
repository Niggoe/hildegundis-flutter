import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:hildegundis_app/ui/AddStrafeDialogUI.dart';
import "package:hildegundis_app/constants.dart";
import "package:hildegundis_app/views/FirebaseViewDetailsTransactions.dart";
import 'package:hildegundis_app/models/Strafe.dart';
import 'package:fcm_push/fcm_push.dart';

class FirebaseViewStrafes extends StatefulWidget {
  static String tag = "firebase-view-Strafes";

  FirebaseViewStrafesState createState() =>
      new FirebaseViewStrafesState();
}

const allowedUsers = [
  "tSFXWNgYNRhzFKXKw3xvaEhCsUB2",
  "q34qmsOSzWWR30I06omGJ3ti0142",
  "v8qunIYGqhNnGPUdykHqFs2ABYW2"
];

class FirebaseViewStrafesState extends State<FirebaseViewStrafes> {
  List<Strafe> allStrafes = new List();

  Widget _makeCard(BuildContext context, DocumentSnapshot document) {
    Strafe currentStrafe = new Strafe();
    currentStrafe.date = document["date"] == '' ? null : document["date"];
    currentStrafe.name = document['name'];
    currentStrafe.grund = document["reason"];
    if (document["amount"].runtimeType == int) {
      currentStrafe.betrag = document["amount"].toDouble();
    } else {
      currentStrafe.betrag = document["amount"];
    }

    return new Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            color: ProjectConfig.BoxDecorationColorDateOverview,
            borderRadius: new BorderRadius.all(const Radius.circular(15.0))),
        child: _buildListItem(context, document),
      ),
    );
  }

  Future<bool> checkAllowedUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future addEventPressed() async {
    bool allowed = await checkAllowedUser();
    if (allowed) {
      Strafe addedStrafe =
          await Navigator.of(context).push(new MaterialPageRoute<Strafe>(
              builder: (BuildContext context) {
                return new AddStrafeDialogUI();
              },
              fullscreenDialog: true));

      final docRef = await Firestore.instance.collection("Strafes").add({
        'name': addedStrafe.name,
        'reason': addedStrafe.grund,
        'amount': addedStrafe.betrag,
        'date': addedStrafe.date,
        'payed':addedStrafe.payed
      }).catchError((e) {
        print(e);
      });

      sendFCMMessage(addedStrafe);
    } else {
      final snackBar = new SnackBar(
        content: new Text(ProjectConfig.TextNotAllowedTransactionEntry),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<int> sendFCMMessage(Strafe strafeAdded) async {
    final FCM fcm = new FCM(ProjectConfig.serverKey);
    final Message fcmMessage = new Message()
      ..to = "/topics/all"
      ..title = "Neue Strafe hinzugefügt"
      ..body = strafeAdded.name +
          " \t" +
          strafeAdded.betrag.toString() +
          "€\n" +
          strafeAdded.grund;
    final String messageID = await fcm.send(fcmMessage);
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    var formatter = new DateFormat("dd.MM.yyyy");
    var date = document['date'];
    var datestring = formatter.format(date);
    bool payed = document['payed'];

    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      key: new ValueKey(document.documentID),
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
        document['name'],
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
            Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),),
            Text(document["amount"].toString() + "€", style: TextStyle(color: ProjectConfig.FontColorDateOverview),)
          ],
        ),
        new Text(document['reason'],
            style: TextStyle(color: ProjectConfig.IconColorDateOverview))
      ]),
      trailing: IconButton(
        icon: (payed ? Icon(Icons.attach_money) : Icon(Icons.money_off)),
        color: (payed ? Colors.green[500] : Colors.red[500]),
        onPressed: () {
          _togglePayed(document);
        },
      ),
      onTap: () {
        var nameKey = document['name'];
        getDocuments(nameKey);
      },
      //onLongPress: () => handleLongPress(document),
    );
  }

  Future _togglePayed(DocumentSnapshot document) async{
    if (await checkAllowedUser()){
      final docRef = await Firestore.instance.collection("Strafes").document(document.documentID).updateData({
        'payed': !document['payed']
      }).catchError((e) {
        print(e);
      });
    } else{
      final snackBar = new SnackBar(
        content: new Text(ProjectConfig.TextNotAllowedTransactionEntry),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> getDocuments(nameKey) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('Strafes')
        .where("name", isEqualTo: nameKey)
        .orderBy('date')
        .getDocuments();
    List<DocumentSnapshot> listOfDocuments = snapshot.documents;
    double totalAmount = 0.0;
    List<Strafe> strafePerName = [];
    for (DocumentSnapshot current in listOfDocuments) {
      totalAmount += current["amount"];
      Strafe currentStrafe = new Strafe();
      currentStrafe.name = current["name"];
      currentStrafe.date = current["date"];
      currentStrafe.betrag = current["amount"];
      currentStrafe.grund = current["reason"];
      currentStrafe.payed = current["payed"];
      strafePerName.add(currentStrafe);
    }
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new FirebaseViewDetailsStrafes(
              name: nameKey,
              strafePerName: strafePerName,
              amount: totalAmount,
            ));
    Navigator.of(context).push(route);
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Strafe>> perNameMap = new Map();
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          addEventPressed();
        },
        child: new Icon(Icons.add),
        tooltip: ProjectConfig.TextFloatingActionButtonTooltipDateOverview,
      ),
      body: new StreamBuilder(
          stream: Firestore.instance
              .collection('Strafes')
              .orderBy('date')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _makeCard(context, snapshot.data.documents[index]),
            );
          }),
    );
  }
}
