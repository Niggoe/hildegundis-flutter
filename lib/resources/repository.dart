import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/models/event.dart';
import 'package:hildegundis_app/models/Fine.dart';
import 'package:hildegundis_app/models/FormationPosition.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> uploadNewDate(Event toAdd) =>
      _firestoreProvider.uploadNewDate(toAdd);

  Future<void> deleteDate(DocumentSnapshot document) =>
      _firestoreProvider.deleteDate(document);

  Future<DocumentReference> addNewDate(Event addedEvent) =>
      _firestoreProvider.addEvent(addedEvent);

  Stream<QuerySnapshot> getAllEvents() => _firestoreProvider.getAllEvents();

  Stream<QuerySnapshot> getAllFines() => _firestoreProvider.getAllFines();

  Future<void> addNewFine(Fine toAdd) => _firestoreProvider.addNewFine(toAdd);

  Future<void> togglePayed(DocumentSnapshot snapshot) =>
      _firestoreProvider.togglePayed(snapshot);

  Stream<QuerySnapshot> getAllFinesForName(String name) =>
      _firestoreProvider.getAllFinesForName(name);

  Future<void> updatePosition(
          FormationPosition old, FormationPosition newPos) =>
      _firestoreProvider.updatePosition(old, newPos);

  Future<void> removePosition(
          FormationPosition old, FormationPosition newPos) =>
      _firestoreProvider.removePosition(old, newPos);

  Future<QuerySnapshot> getAllPositions(int formation) =>
      _firestoreProvider.getAllPositions(formation);

  Future<int> authenticateUser(String email, String password) =>
      _firestoreProvider.authenticateUser(email, password);

  Future<bool> checkLoginUser() => _firestoreProvider.checkAuthenticated();

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<void> logoutUser() => _firestoreProvider.logoutUser();
}
