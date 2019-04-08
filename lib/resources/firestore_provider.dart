import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app/modelsOLD/event.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> uploadNewDate(Event toAdd) async {
    return await _firestore.collection("events").add({
      'name': toAdd.title,
      'clothes': toAdd.clothes,
      'location': toAdd.location,
      'date': toAdd.timepoint
    }).catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> getAllEvents() {
    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: new DateTime.now())
        .orderBy('date')
        .snapshots();
  }
}
