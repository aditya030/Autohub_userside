import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    var user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).set(userData);
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    var user = _auth.currentUser;
    if (user != null) {
      var docSnapshot = await _db.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    }
    return null;
  }
}
