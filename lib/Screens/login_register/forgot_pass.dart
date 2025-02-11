import 'package:electronicsrent/components/my_button.dart';
import 'package:electronicsrent/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
          showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("password reset link sent to your email"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 135, left: 20, right: 20),
        child: Column(
          children: [
            const Text("enter your email we will send reset password link"),
            const SizedBox(
              height: 20,
            ),
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: "Reset password",
              onTap: passwordReset,
            ),
          ],
        ),
      ),
    );
  }
}
