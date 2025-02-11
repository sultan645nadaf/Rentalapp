import 'dart:async';
import 'package:electronicsrent/Screens/authentication_screen/otp_screen.dart';
import 'package:electronicsrent/Screens/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(BuildContext context, String uid) async {
    User? user = auth.currentUser;

    if (user != null) {
      final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();

      List<DocumentSnapshot> document = result.docs;

      if (document.isNotEmpty) {
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      } else {
        await users.doc(user.uid).set({
          'uid': user.uid,
          'mobile': user.phoneNumber,
          'email': user.email
        }).then((value) {
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        // ignore: invalid_return_type_for_catch_error
        }).catchError((error) => print("Failed to add user: $error"));
      }
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      await addUser(context, auth.currentUser?.uid ?? "");
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid');
      }
      print('The error is ${e.code}');
    };

    final PhoneCodeSent codeSent = (String verId, int? resendToken) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            number: number,
            verId: verId,
          ),
        ),
      );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print(verificationId);
    };

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  Future<void> signInWithPhoneNumber(BuildContext context, String verId, String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: otp,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);

      await addUser(context, userCredential.user?.uid ?? "");
    } catch (e) {
      print('Failed to sign in: ${e.toString()}');
    }
  }
}
