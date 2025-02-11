import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electronicsrent/Screens/main_screen.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  static const String id = 'user_details_screen';

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _contact = '';

  Future<void> _submitForm(
      String productId, String productName, String? productImageUrl) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('users').add({
        'name': _name,
        'contact': _contact,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Product Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                productImageUrl != null
                    ? Container(
                        width: 100.0, // Set the desired width
                        height: 100.0, // Set the desired height
                        child: Image.network(
                          productImageUrl,
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit
                              .cover, // Ensures the image covers the container while maintaining aspect ratio
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                Text(productName),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Product confirmed!'),
                  ));
                  Navigator.of(context).pop(); // Close the UserDetailsScreen
                  Navigator.of(context).pushReplacementNamed(
                      MainScreen.id); // Navigate to the home page
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String productId = args['productId'] as String;
    String productName = args['productName'] as String;
    String? productImageUrl = args['productImageUrl'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact information';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contact = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm(productId, productName, productImageUrl);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
