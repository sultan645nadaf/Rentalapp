import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:electronicsrent/Screens/models/cart_item.dart';
import 'package:electronicsrent/Screens/services/cart_service.dart';
import 'package:electronicsrent/Screens/item_detail_screen.dart';

class CartScreen extends StatelessWidget {
  static const String id = 'cart-screen';

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartService.items.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartService.items.length,
              itemBuilder: (context, index) {
                CartItem cartItem = cartService.items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ItemDetailScreen.id,
                      arguments: cartItem.product,
                    );
                  },
                  child: ListTile(
                    leading: Image.network(cartItem.product.imageUrls.isNotEmpty ? cartItem.product.imageUrls[0] : ''), // Display the first image URL if available
                    title: Text(cartItem.product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${cartItem.quantity}'),
                        Text('Per Day Price: \$${cartItem.product.price.toStringAsFixed(2)}'), // Assuming this is the price per day
                        Text('Total: \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'), // Total price for the quantity
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        cartService.removeItem(cartItem);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
