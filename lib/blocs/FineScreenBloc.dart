import 'package:hildegundis_app/resources/repository.dart';
import 'package:hildegundis_app/models/Fine.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FineScreenBloc {
  final _repository = Repository();
  final _fines = BehaviorSubject<Fine>();

  Stream<QuerySnapshot> getAllFines() {
    return _repository.getAllFines();
  }

  Future<void> addNewFine(Fine fine) {
    return _repository.addNewFine(fine);
  }

  Future<void> togglePayed(DocumentSnapshot snapshot) {
    return _repository.togglePayed(snapshot);
  }

  Stream<QuerySnapshot> getAllFinesForName(String name) {
    return _repository.getAllFinesForName(name);
  }
}
