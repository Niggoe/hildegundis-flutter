import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'strafe.dart';

class DialogAddStrafe extends StatefulWidget {
  @override
  _DialogAddStrafeState createState() => new _DialogAddStrafeState();
}

class _DialogAddStrafeState extends State<DialogAddStrafe> {
  Strafe newStrafe = new Strafe();

  final TextEditingController _controller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _names = <String>[
    '',
    'Daniel C.',
    'Daniel T.',
    'Fabian',
    'Jonas',
    'Konstantin',
    'Martin',
    'Maximilian',
    'Michael',
    'Nicolas',
    'Nikolas',
    'Patrick',
    'Roman',
    'Thomas H.',
    'Thomas W.',
  ];

  String _name = '';

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: const Text('Neue Strafe'), actions: <Widget>[
        new FlatButton(
            child: new Text('Speichern',
                style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              _submitForm();
            })
      ]),
      body: new Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            new InputDecorator(
              decoration: const InputDecoration(
                  icon: const Icon(Icons.people), labelText: 'Wer?'),
              isEmpty: _name == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _name,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _name = newValue;
                      newStrafe.name = newValue;
                    });
                  },
                  items: _names.map((String value) {
                    return new DropdownMenuItem<String>(
                        value: value, child: new Text(value));
                  }).toList(),
                ),
              ),
            ),
            new Row(children: <Widget>[
              new Expanded(
                  child: new TextFormField(
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Wann war es?',
                        labelText: 'Datum',
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                      onSaved: (val) => newStrafe.date = convertToDate(val))),
              new IconButton(
                icon: new Icon(Icons.more_horiz),
                tooltip: 'Choose date',
                onPressed: (() {
                  _chooseDate(context, _controller.text);
                }),
              )
            ]),
            new TextFormField(
              decoration: const InputDecoration(
                  labelText: "Grund", icon: const Icon(Icons.receipt)),
              validator: (val) =>
                  val.isEmpty ? 'Ein Grund wird benötigt' : null,
              onSaved: (String value) {
                newStrafe.grund = value;
              },
            ),
            new TextFormField(
              decoration: const InputDecoration(
                  labelText: "Betrag", icon: const Icon(Icons.receipt)),
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val.isEmpty ? 'Ein Betrag wird benötigt' : null,
              onSaved: (String value) {
                newStrafe.betrag = double.parse(value);
              },
            )
          ].toList(),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Es ist nicht alles ausgefüllt - Bitte korrigieren');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Name: ${newStrafe.name}');
      print('Datum: ${newStrafe.date}');
      print('Grund: ${newStrafe.grund}');
      print('Betrag: ${newStrafe.betrag}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
      Navigator.of(context).pop(newStrafe);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
