import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electronicsrent/Screens/models/user_model.dart';

import '../models/product.dart';


class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all products
  Future<List<Product>> getProducts() async {
    QuerySnapshot snapshot = await _db.collection('electronics_items').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // Add a new product
  Future<String> addProduct(Map<String, dynamic> productData) async {
    DocumentReference docRef = await _db.collection('electronics_items').add(productData);
    return docRef.id;
  }

  // Fetch a single product by ID
  Future<Map<String, dynamic>> getProduct(String productId) async {
    DocumentSnapshot doc = await _db.collection('electronics_items').doc(productId).get();
    return doc.data() as Map<String, dynamic>;
  }

  // Remove a product
  Future<void> removeProduct(Product product) async {
    await _db.collection('electronics_items').doc(product.id).delete();
  }

  // Add user details
  Future<void> addUserDetails(Map<String, dynamic> userDetails) async {
    await _db.collection('users').add(userDetails);
  }

  // Fetch user details by user ID
   Future<UserModel?> getUserDetails(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> userData) async {
    await _db.collection('users').doc(userId).update(userData);
  }
}
