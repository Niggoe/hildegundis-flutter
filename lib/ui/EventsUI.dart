import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import "package:hildegundis_app/ui/EventDetailUI.dart";
import "package:hildegundis_app/constants.dart";
import "dart:async";
import "package:firebase_auth/firebase_auth.dart";
import "package:hildegundis_app/models/event.dart";
import 'package:hildegundis_app/ui/AddEventDialogUI.dart';
import 'package:fcm_push/fcm_push.dart';
import 'package:hildegundis_app/blocs/EventScreenBlocProvider.dart';
import 'package:hildegundis_app/blocs/EventScreenBloc.dart';

class EventsUI extends StatefulWidget {
  static String tag = "firebase-view-dates";
  _EventsUIState createState() => new _EventsUIState();
}

const allowedUsers = [
  "tSFXWNgYNRhzFKXKw3xvaEhCsUB2",
  "q34qmsOSzWWR30I06omGJ3ti0142",
  "v8qunIYGqhNnGPUdykHqFs2ABYW2"
];

class _EventsUIState extends State<EventsUI> {
  EventScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = EventScreenBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

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

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    var formatter = new DateFormat("dd.MM.yyyy HH:mm");
    var date = document['date'];
    var datestring = formatter.format(date);

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
      subtitle: new Row(
        children: <Widget>[
          Icon(Icons.linear_scale, color: ProjectConfig.IconColorDateOverview),
          Text(datestring + " Uhr",
              style: TextStyle(color: ProjectConfig.FontColorDateOverview))
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: ProjectConfig.FontColorDateOverview, size: 30.0),
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new EventDetailUI(snapshot: document));
        Navigator.of(context).push(route);
      },
      onLongPress: () => handleLongPress(document),
      /* onTap: () => Firestore.instance.runTransaction((transaction) async {
            DocumentSnapshot freshSnap =
                await transaction.get(document.reference);
            await transaction
                .update(freshSnap.reference, {'votes': freshSnap['votes'] + 1});
          } */
    );
  }

  Future addEventPressed() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        final snackBar = new SnackBar(
          content: new Text(ProjectConfig.TextNotAllowedDateEntry),
          backgroundColor: Colors.red,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        Event addedEvent =
            await Navigator.of(context).push(new MaterialPageRoute<Event>(
                builder: (BuildContext context) {
                  return new AddEventDialogUI();
                },
                fullscreenDialog: true));

        _bloc.addEvent(addedEvent);
        sendFCMMessage(addedEvent);
      }
    } else {
      final snackBar = new SnackBar(
        content: new Text(ProjectConfig.TextNotLoggedInSnackbarMessage),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<int> sendFCMMessage(Event newEvent) async {
    final FCM fcm = new FCM(ProjectConfig.serverKey);
    final Message fcmMessage = new Message()
      ..to = "/topics/all"
      ..title = "Neuer Termin hinzugefügt"
      ..body = newEvent.title +
          " \t" +
          DateFormat.yMMMd().format(newEvent.timepoint) +
          "\n" +
          newEvent.location;
    await fcm.send(fcmMessage);
  }

  Future handleLongPress(DocumentSnapshot document) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var user_id = user.uid;
      if (!allowedUsers.contains(user_id)) {
        final snackBar = new SnackBar(
          content: new Text(ProjectConfig.TextNotAllowedDateRemoval),
          backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content:
                    new Text(ProjectConfig.TextDateOverviewTryToDeleteEvent),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        _bloc.deleteEvent(document);
                        Navigator.pop(context);
                      },
                      child: new Text(
                          ProjectConfig.TextDeleteEventDialogOptionYes)),
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          new Text(ProjectConfig.TextDeleteEventDialogOptionNo))
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          addEventPressed();
        },
        child: new Icon(Icons.add),
        tooltip: ProjectConfig.TextFloatingActionButtonTooltipDateOverview,
      ),
      body: new StreamBuilder(
          stream: _bloc.getAllEvents(),
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
