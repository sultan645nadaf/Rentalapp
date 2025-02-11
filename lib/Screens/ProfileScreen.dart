import 'package:electronicsrent/Screens/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:electronicsrent/Screens/services/auth_services.dart';
import 'package:electronicsrent/Screens/services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _profileImageUrl = '';

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: authService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found'));
          } else {
            UserModel user = snapshot.data!;
            _name = user.name;
            _email = user.email;
            _profileImageUrl = user.profileImageUrl;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_profileImageUrl),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _name,
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
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Save user data to Firestore
                          await databaseService.updateUserProfile(
                            user.uid,
                            {
                              'name': _name,
                              'email': _email,
                              'profileImageUrl': _profileImageUrl,
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile updated!')),
                          );
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
