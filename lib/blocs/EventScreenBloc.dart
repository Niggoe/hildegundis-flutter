import 'package:flutter/material.dart';
import 'package:hildegundis_app/resources/repository.dart';
import 'package:hildegundis_app/modelsOLD/event.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class EventScreenBloc {
  final _repository = Repository();
  final _dates = BehaviorSubject<Event>();

  Observable<Event> get events => _dates.stream.transform(_checkEvent);

  final _checkEvent =
      StreamTransformer<Event, Event>.fromHandlers(handleData: (events, sink) {
    if (events.getTitle().length > 10) {
      sink.add(events);
    }
  });

  Stream<QuerySnapshot> getAllEvents() {
    return _repository.getAllEvents();
  }

  void dispose() async {
    _dates.close();
  }
}
