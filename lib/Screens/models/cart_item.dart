import 'package:electronicsrent/Screens/models/product.dart';

class CartItem {
  final Product product;
    int quantity;
  int days; // Added field for rental days

  CartItem({
    required this.product,
    required this.quantity,
    required this.days, // Added field for rental days
  });

  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
  }

  void updateDays(int newDays) {
    days = newDays;
  }
}
