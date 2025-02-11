//import 'package:electronicsrent/Screens/services/auth_services.dart';
import 'package:electronicsrent/components/helper_function.dart';
import 'package:electronicsrent/components/my_button.dart';
import 'package:electronicsrent/components/my_textfield.dart';
//import 'package:electronicsrent/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasController = TextEditingController();

  // Register method
  Future<void> registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Make sure passwords match
    if (passwordController.text != confirmPasController.text) {
      // Pop loading circle
      Navigator.pop(context);

      // Show error message to user
      displayMessageToUser("Passwords don't match!", context);
    } else {
      try {
        // Create the user
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Pop loading circle
        Navigator.pop(context);

        // Show success message
        displayMessageToUser("Registration successful!", context);

        // Navigate to another screen if needed
      } on FirebaseAuthException catch (e) {
        // Pop loading circle
        Navigator.pop(context);

        // Display error message to user
        displayMessageToUser(e.message ?? "An error occurred", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.person,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 25),
                const Text(
                  "E-Rent",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  hintText: "Username",
                  obscureText: false,
                  controller: userNameController,
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPasController,
                ),
                const SizedBox(height: 10),
                
                const SizedBox(height: 10),
                MyButton(
                  text: "Register",
                  onTap: registerUser,
                ),
                const SizedBox(height: 10),
               
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
