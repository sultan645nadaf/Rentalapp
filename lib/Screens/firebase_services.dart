import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electronicsrent/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateUser(Map<String, dynamic> data, BuildContext context) {
    return users.doc(user?.uid).update(data).then(
      (value) {
        Navigator.pushNamed(context, HomeScreen.id);
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }
}
