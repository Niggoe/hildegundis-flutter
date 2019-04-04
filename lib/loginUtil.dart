import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

Future<bool> userIsLoggedIn() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if (user != null && user.uid.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
