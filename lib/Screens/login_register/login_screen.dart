import 'package:electronicsrent/Screens/location_screen.dart';
import 'package:electronicsrent/components/widget/auth_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out');
      } else {
        Navigator.popAndPushNamed(context, LocationScreen.id);
      }
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(197, 235, 235, 235),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    'assets/images/images.png',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Electronic rent',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade900),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: AuthUi(),
            ),
          ),
        ],
      ),
    );
  }
}
