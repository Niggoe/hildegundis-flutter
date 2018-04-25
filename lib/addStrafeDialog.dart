import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class DialogAddStrafe extends StatefulWidget {
  @override
  _DialogAddStrafeState createState() => new _DialogAddStrafeState();
}

class ModelData {
  String name;
  String grund;
  String date;
  double amount;
  int number;

  ModelData(this.name, this.grund, this.date, this.amount, this.number);

  ModelData.empty() {
    name = "";
    grund = "";
    date = "";
    amount = 0.0;
    number = 0;
  }
}

class _DialogAddStrafeState extends State<DialogAddStrafe> {
  bool _canSave = false;
  ModelData _data = new ModelData.empty();
  final TextEditingController _controller = new TextEditingController();

  void _setCanSave(bool save) {
    if (save != _canSave) setState(() => _canSave = save);
  }

  
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
      appBar: new AppBar(title: const Text('Neue Strafe'), actions: <Widget>[
        new FlatButton(
            child: new Text('Speichern',
                style: theme.textTheme.body1.copyWith(
                    color: _canSave
                        ? Colors.white
                        : new Color.fromRGBO(255, 255, 255, 0.5))),
            onPressed: _canSave
                ? () {
                    Navigator.of(context).pop(_data);
                  }
                : null)
      ]),
      body: new Form(
        child: new ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
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
              )),
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
              onSaved: (String value) {
                _data.name = value;
                _setCanSave(value.isNotEmpty);
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
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Email: ${newContact.name}');
      print('Dob: ${newContact.dob}');
      print('Phone: ${newContact.phone}');
      print('Email: ${newContact.email}');
      print('Favorite Color: ${newContact.favoriteColor}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
    }
  }

    void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
