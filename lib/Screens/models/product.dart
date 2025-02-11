import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  double price;
  String sellerAddress;
  List<String> imageUrls; // List to store image URLs

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.sellerAddress,
    required this.imageUrls,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    // Ensure data is not null before accessing fields
    if (data == null) {
      throw Exception('Product data is null!');
    }

    // Extract image URLs from Firestore document
    List<String> imageUrls = [];
    if (data['imageUrls'] != null && data['imageUrls'] is List) {
      imageUrls = List<String>.from(data['imageUrls']);
    }

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      sellerAddress: data['sellerAddress'] ?? '',
      imageUrls: imageUrls,
    );
  }
}
