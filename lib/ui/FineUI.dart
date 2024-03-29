import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:hildegundis_app/ui/AddFineDialogUI.dart';
import "package:hildegundis_app/constants.dart";
import "package:hildegundis_app/ui/FineDetailUI.dart";
import 'package:hildegundis_app/models/Fine.dart';
import 'package:fcm_push/fcm_push.dart';
import 'package:hildegundis_app/blocs/FineScreenBloc.dart';
import 'package:hildegundis_app/blocs/FineScreenBlocProvider.dart';

class FineUI extends StatefulWidget {
  static String tag = "firebase-view-Strafes";

  FineUIState createState() => new FineUIState();
}

const allowedUsers = [
  "tSFXWNgYNRhzFKXKw3xvaEhCsUB2",
  "q34qmsOSzWWR30I06omGJ3ti0142",
  "v8qunIYGqhNnGPUdykHqFs2ABYW2"
];

class FineUIState extends State<FineUI> {
  List<Fine> allStrafes = new List();
  FineScreenBloc _bloc;

  Widget _makeCard(BuildContext context, DocumentSnapshot document) {
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
    User user = await FirebaseAuth.instance.currentUser;
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
      Fine addedFine =
          await Navigator.of(context).push(new MaterialPageRoute<Fine>(
              builder: (BuildContext context) {
                return new AddFineDialogUI();
              },
              fullscreenDialog: true));

      _bloc.addNewFine(addedFine);
      sendFCMMessage(addedFine);
    } else {
      final snackBar = new SnackBar(
        content: new Text(ProjectConfig.TextNotAllowedTransactionEntry),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<int> sendFCMMessage(Fine strafeAdded) async {
    final FCM fcm = new FCM(ProjectConfig.serverKey);
    final Message fcmMessage = new Message()
      ..to = "/topics/all"
      ..title = "Neue Strafe hinzugefügt"
      ..body = strafeAdded.name +
          " \t" +
          strafeAdded.amount.toString() +
          "€\n" +
          strafeAdded.reason;
    final String messageID = await fcm.send(fcmMessage);
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    var formatter = new DateFormat("dd.MM.yyyy");
    var date = document['date'].toDate();
    var datestring = formatter.format(date);
    bool payed = document['payed'];

    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      key: new ValueKey(document.id),
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
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            ),
            Text(
              document["amount"].toString() + "€",
              style: TextStyle(color: ProjectConfig.FontColorDateOverview),
            )
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

  Future _togglePayed(DocumentSnapshot document) async {
    if (await checkAllowedUser()) {
      _bloc.togglePayed(document);
    } else {
      final snackBar = new SnackBar(
        content: new Text(ProjectConfig.TextNotAllowedTransactionEntry),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void getDocuments(nameKey) {
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new FineScreenBlocProvider(
              child: FineDetailUI(name: nameKey),
            ));
    Navigator.of(context).push(route);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = FineScreenBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Fine>> perNameMap = new Map();
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          addEventPressed();
        },
        child: new Icon(Icons.add),
        tooltip: ProjectConfig.TextFloatingActionButtonTooltipDateOverview,
      ),
      body: new StreamBuilder(
          stream: _bloc.getAllFines(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  _makeCard(context, snapshot.data.docs[index]),
            );
          }),
    );
  }
}
