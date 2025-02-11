import 'package:electronicsrent/Screens/models/cart_item.dart';
import 'package:electronicsrent/Screens/models/product.dart';
import 'package:flutter/material.dart';

class CartService extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product, int days) {
    for (CartItem item in _items) {
      if (item.product.id == product.id) {
        item.updateQuantity(item.quantity + 1);
        item.updateDays(days); // Update the days as well
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product, quantity: 1, days: days));
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
