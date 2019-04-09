import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/models/event.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> uploadNewDate(Event toAdd) =>
      _firestoreProvider.uploadNewDate(toAdd);

  Future<void> deleteDate(DocumentSnapshot document) => _firestoreProvider.deleteDate(document);

  Future<DocumentReference> addNewDate(Event addedEvent) => _firestoreProvider.addEvent(addedEvent);

  Stream<QuerySnapshot> getAllEvents() => _firestoreProvider.getAllEvents();


}
