import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');
  dynamic userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<List<Map<String, dynamic>>> getProfilesStream() {
    return _usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<Object?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot<Object?> snapshot =
          await _usersCollection.doc(userId).get();

      if (snapshot.exists) {
        // User profile found, return the data
        userProfile = snapshot.data();
        return snapshot.data();
      } else {
        // User profile does not exist
        return null;
      }
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  isHide(uid, hide) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set({'isHide': hide}, SetOptions(merge: true));
  }

  isDelete(uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set({'isdelete': "true"}, SetOptions(merge: true));
  }
}
