import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');
  dynamic userProfile;
  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _usersCollection.get();
      print(querySnapshot);
      // Extract data from QuerySnapshot
      List<Map<String, dynamic>> profiles = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return profiles;
    } catch (e) {
      print('Error getting profiles: $e');
      return [];
    }
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
}
