import 'package:firebase_auth/firebase_auth.dart';
import 'package:electronicsrent/Screens/models/user_model.dart';
import 'package:electronicsrent/Screens/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  // Get the current Firebase user
  User? getCurrentFirebaseUser() {
    return _auth.currentUser;
  }

  // Get the current user details from Firestore
  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = getCurrentFirebaseUser();
    if (firebaseUser != null) {
      return await _databaseService.getUserDetails(firebaseUser.uid);
    }
    return null;
  }
}
