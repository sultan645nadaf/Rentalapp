import 'package:electronicsrent/Screens/authentication_screen/auth.dart';
import 'package:electronicsrent/Screens/services/google_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:electronicsrent/Screens/home_screen.dart';
import 'package:electronicsrent/Screens/authentication_screen/phone_auth.dart';
//import 'google_auth_service.dart'; // import your google auth service

class AuthUi extends StatelessWidget {
  const AuthUi({super.key});

  @override
  Widget build(BuildContext context) {
  
    final googleAuthService =
        GoogleAuthService(); // create an instance of GoogleAuthService

    return Center(
      child: Padding(
        
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          mainAxisSize: MainAxisSize.min,
          children: [
            
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuth.id);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_android_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Continue with Phone',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  User? user =
                      await googleAuthService.signInWithGoogle(context);
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.login,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'or',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AuthPage.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Login with Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
