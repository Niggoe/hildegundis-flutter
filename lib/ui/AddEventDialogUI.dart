import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hildegundis_app/models/event.dart';
import 'package:flutter/cupertino.dart';

class AddEventDialogUI extends StatefulWidget {
  @override
  _AddEventDialogUIState createState() => new _AddEventDialogUIState();
}

const double _kPickerSheetHeight = 216.0;

class _AddEventDialogUIState extends State<AddEventDialogUI> {
  DateTime dateTimeDate;
  TimeOfDay dateTimeTime = new TimeOfDay.now();
  String date;
  String timeString;

  Event newEvent = new Event();

  final TextEditingController _controllerDate = new TextEditingController();
  final TextEditingController _controllerTime = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
          title: const Text('Neuer Termin'),
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            new FlatButton(
                child: new Text('Speichern',
                    style: theme.textTheme.body1.copyWith(color: Colors.white)),
                onPressed: () {
                  _submitForm();
                })
          ]),
      body: new Form(
          key: _formKey,
          child: new ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            children: <Widget>[
              new TextFormField(
                decoration: const InputDecoration(
                    labelText: "Titel", icon: const Icon(Icons.receipt)),
                validator: (val) =>
                    val.isEmpty ? 'Der Name wird benötigt' : null,
                onSaved: (String value) {
                  newEvent.title = value;
                },
              ),
              new TextFormField(
                decoration: const InputDecoration(
                    labelText: "Ort", icon: const Icon(Icons.receipt)),
                validator: (val) =>
                    val.isEmpty ? 'Der Ort wird benötigt' : null,
                onSaved: (String value) {
                  newEvent.location = value;
                },
              ),
              new TextFormField(
                decoration: const InputDecoration(
                    labelText: "Kleidung", icon: const Icon(Icons.receipt)),
                validator: (val) =>
                    val.isEmpty ? 'Die Kleidung wird benötigt' : null,
                onSaved: (String value) {
                  newEvent.clothes = value;
                },
              ),
              new Row(children: <Widget>[
                new Expanded(
                    child: new TextFormField(
                        decoration: new InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Wann war es?',
                          labelText: 'Datum',
                        ),
                        controller: _controllerDate,
                        validator: (val) =>
                            val.isEmpty ? 'Das Datum wird benötigt' : null,
                        keyboardType: TextInputType.datetime,
                        onSaved: (val) => date = val)),
                new IconButton(
                  icon: new Icon(Icons.more_horiz),
                  tooltip: 'Choose date',
                  onPressed: (() {
                    _chooseDate(context, _controllerDate.text);
                  }),
                )
              ]),
              new Row(children: <Widget>[
                new Expanded(
                    child: new TextFormField(
                        decoration: new InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Wie viel Uhr?',
                          labelText: 'Uhrzeit',
                        ),
                        controller: _controllerTime,
                        validator: (val) =>
                            val.isEmpty ? 'Die Uhrzeit wird benötigt' : null,
                        keyboardType: TextInputType.datetime,
                        onSaved: (val) => date = val)),
                new IconButton(
                  icon: new Icon(Icons.more_horiz),
                  tooltip: 'Choose date',
                  onPressed: (() {
                    _chooseTime(context, _controllerTime.text);
                  }),
                )
              ]),
            ],
          )),
    );
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    _controllerDate.text = DateFormat.yMMMd().format(initialDate);
    dateTimeDate = initialDate;
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _controllerDate.text = DateFormat.yMMMd().format(newDateTime);
                dateTimeDate = newDateTime;
              });
            },
          ));
        });
  }

  Future _chooseTime(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    _controllerTime.text = DateFormat.Hm().format(initialDate);
    dateTimeTime = TimeOfDay.fromDateTime(initialDate);
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDate,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _controllerTime.text = new DateFormat.Hm().format(newDateTime);
                dateTimeTime = TimeOfDay.fromDateTime(newDateTime);
              });
            },
          ));
        });
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Es ist nicht alles ausgefüllt - Bitte korrigieren');
    } else {
      form.save(); //This invokes each onSaved event

      newEvent.id = DateTime.now().millisecondsSinceEpoch;
      DateTime eventDate = new DateTime(dateTimeDate.year, dateTimeDate.month,
          dateTimeDate.day, dateTimeTime.hour, dateTimeTime.minute);
      newEvent.timepoint = eventDate;
      Navigator.of(context).pop(newEvent);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
