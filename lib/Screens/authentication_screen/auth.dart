import 'package:electronicsrent/Screens/authentication_screen/login_or_register.dart';
//import 'package:electronicsrent/Screens/home_screen.dart';
import 'package:electronicsrent/Screens/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:rent/pages/home_page.dart';


class AuthPage extends StatelessWidget {

   static const String id = 'auth-screen';
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return  LocationScreen();
          }
          // user not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
