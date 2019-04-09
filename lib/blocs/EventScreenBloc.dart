import 'package:flutter/material.dart';
import 'package:hildegundis_app/resources/repository.dart';
import 'package:hildegundis_app/models/event.dart';
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


  Future<void> deleteEvent(DocumentSnapshot document){
    return _repository.deleteDate(document);
  }

  Future<DocumentReference> addEvent(Event newEvent){
    return _repository.addNewDate(newEvent);
  }

  Stream<QuerySnapshot> getAllEvents() {
    return _repository.getAllEvents();
  }

  void dispose() async {
    _dates.close();
  }
}
