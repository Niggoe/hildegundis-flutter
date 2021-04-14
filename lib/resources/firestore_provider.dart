import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hildegundis_app/models/event.dart';
import 'package:hildegundis_app/models/Fine.dart';
import 'package:hildegundis_app/models/FormationPosition.dart';

class FirestoreProvider {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> deleteDate(DocumentSnapshot document) async {
    return await _firestore.collection('events').doc(document.id).delete();
  }

  Future<DocumentReference> addEvent(Event addedEvent) async {
    return await _firestore.collection("events").add({
      'name': addedEvent.title,
      'clothes': addedEvent.clothes,
      'location': addedEvent.location,
      'date': addedEvent.timepoint
    });
  }

  Stream<QuerySnapshot> getAllEvents() {
    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: new DateTime.now())
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot> getAllFines() {
    return _firestore.collection('transactions').orderBy('date').snapshots();
  }

  Future<void> addNewFine(Fine newFine) {
    return _firestore.collection("transactions").add({
      'name': newFine.name,
      'reason': newFine.reason,
      'amount': newFine.amount,
      'date': newFine.date,
      'payed': newFine.payed
    });
  }

  Future<void> togglePayed(DocumentSnapshot snapshot) {
    return _firestore
        .collection("transactions")
        .doc(snapshot.id)
        .update({'payed': !snapshot['payed']});
  }

  Stream<QuerySnapshot> getAllFinesForName(String name) {
    return _firestore
        .collection("transactions")
        .where("name", isEqualTo: name)
        .orderBy("date")
        .snapshots();
  }

  Future<void> updatePosition(FormationPosition old, FormationPosition newPos) {
    return _firestore
        .collection('formation')
        .doc(old.documentID)
        .update({'position': newPos.position});
  }

  Future<void> removePosition(FormationPosition old, FormationPosition newPos) {
    return _firestore
        .collection('formation')
        .doc(old.documentID)
        .update({'position': -1});
  }

  Future<QuerySnapshot> getAllPositions(int formation) {
    return _firestore
        .collection('formation')
        .where("formation", isEqualTo: formation)
        .orderBy('position')
        .get();
  }

  Future<int> authenticateUser(String email, String password) async {
    try {
      var user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //print("Signed in: ${user.uid}");
      return 1;
    } catch (e) {
      print("Error $e");
      return 0;
    }
  }

  Future<bool> checkAuthenticated() async {
    try {
      var user = await FirebaseAuth.instance.currentUser;
      print(user);
      bool loggedIn = user != null;
      print(loggedIn.toString() + " user state");
      return (user != null);
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

  Future<void> registerUser(String email, String password) async {
    return _firestore
        .collection("users")
        .doc(email)
        .set({'email': email, 'password': password, 'admin': false});
  }

  Future<void> logoutUser() async {
    print("log out user");
    FirebaseAuth.instance.signOut();
  }
}
