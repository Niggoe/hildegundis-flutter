import 'package:flutter/material.dart';
import 'package:hildegundis_app/resources/repository.dart';
import 'package:hildegundis_app/modelsOLD/event.dart';
import 'package:rxdart/rxdart.dart';


class EventScreenBloc{
  final _repository = Repository();
  final _dates = BehaviorSubject<Event>();
}