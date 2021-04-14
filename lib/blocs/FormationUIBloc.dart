import 'package:hildegundis_app/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/models/FormationPosition.dart';
import 'dart:async';

class FormationUIBloc {
  final _repository = Repository();

  Future<void> updatePosition(FormationPosition old, FormationPosition newPos) {
    return _repository.updatePosition(old, newPos);
  }

  Future<void> removePosition(FormationPosition old, FormationPosition newPos) {
    return _repository.removePosition(old, newPos);
  }

  Future<QuerySnapshot> getAllPositions(int formation) {
    return _repository.getAllPositions(formation);
  }
}
