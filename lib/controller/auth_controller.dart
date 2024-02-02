import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpworld_admin/utils/popup.dart';

Future<bool> signUpWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Print information about the signed-up user
    print('User ID: ${userCredential.user?.uid}');
    print('User email: ${userCredential.user?.email}');
    showSuccessSnackBar(context, 'Operation was successful!');

    // Return true to indicate success
    return true;
  } catch (e) {
    // Print the error if sign-up fails
    showErrorSnackBar(context, 'An error occurred: $e');
    print('Error: ${e.toString()}');

    // Return false to indicate failure
    return false;
  }
}

Future<bool> signInWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User ID: ${userCredential.user?.uid}');
    print('User email: ${userCredential.user?.email}');
    showSuccessSnackBar(context, 'Login successful!');

    // Return true to indicate success
    return true;

    // You can perform additional actions after successful sign-in if needed
  } catch (e) {
    showErrorSnackBar(context, 'An error occurred: $e');
    print('Error: ${e.toString()}');

    // Return false to indicate failure
    return false;
  }
}
