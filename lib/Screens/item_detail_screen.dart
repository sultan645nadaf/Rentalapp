import 'package:electronicsrent/Screens/models/cart_item.dart';
import 'package:electronicsrent/Screens/models/product.dart';
import 'package:electronicsrent/Screens/payment_screen.dart';
import 'package:electronicsrent/Screens/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  static const String id = 'item-detail-screen';
  final Product product;

  ItemDetailScreen({required this.product});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _days = 1;
  double _totalCost = 0;

  @override
  void initState() {
    super.initState();
    _totalCost = widget.product.price * _days;
  }

  void _updateTotalCost(int days) {
    setState(() {
      _days = days;
      _totalCost = widget.product.price * days;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: widget.product.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.product.imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Seller Address: ${widget.product.sellerAddress}'),
                  SizedBox(height: 8),
                  Text(
                    'Per Day Cost: ₹${widget.product.price.toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 16),
                  Text('Select Number of Days:'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _days.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          label: '$_days days',
                          onChanged: (value) {
                            _updateTotalCost(value.toInt());
                          },
                        ),
                      ),
                      Text('$_days days'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Total Cost: ₹${_totalCost.toStringAsFixed(2)}'),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        // Create a CartItem instance and navigate to PaymentScreen
                        CartItem cartItem = CartItem(
                          product: widget.product,
                          quantity: 1, // Assuming 1 item for rental
                          days: _days,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              amount: _totalCost,
                              cartItem: cartItem,
                            ),
                          ),
                        );
                        cartService.addItem(widget.product, _days);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.name} booked for $_days days'),
                          ),
                        );
                      },
                      child: Center(child: Text('Book Now')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
