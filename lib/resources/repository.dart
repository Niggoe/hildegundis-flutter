import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/modelsOLD/event.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> uploadNewDate(Event toAdd) =>
      _firestoreProvider.uploadNewDate(toAdd);

  Stream<QuerySnapshot> getAllEvents() => _firestoreProvider.getAllEvents();
}
