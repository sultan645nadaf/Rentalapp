import 'package:electronicsrent/Screens/main_screen.dart';
import 'package:electronicsrent/Screens/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:electronicsrent/Screens/services/database_service.dart';


class PaymentScreen extends StatelessWidget {
  static const String id = 'payment-screen';
  final double amount;
  final CartItem cartItem;

  const PaymentScreen({Key? key, required this.amount, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Amount: \₹${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Dummy payment success logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment Successful!')),
                );

                // Remove the item from the database
                await dbService.removeProduct(cartItem.product);

                //  cartService.removeItem(cartItem);

                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Payment Confirmation'),
                      content: Text('Payment was successful.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.id, (route) => false);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
