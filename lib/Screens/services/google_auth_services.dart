import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Sign out any existing Google user to prompt account selection
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Check if the user document already exists
          final DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          // If the document does not exist, create a new one
          if (!userDoc.exists) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'displayName': user.displayName,
              'photoURL': user.photoURL,
              'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
            });
          } else {
            // If the document exists, update it with the latest information
            await _firestore.collection('users').doc(user.uid).update({
              'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
            });
          }

          return user;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in with Google: $e')));
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }
}
