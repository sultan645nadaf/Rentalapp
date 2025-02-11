import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:electronicsrent/Screens/ProfileScreen.dart';
import 'package:electronicsrent/Screens/add_item_categories.dart';
import 'package:electronicsrent/Screens/cart_screen.dart';
import 'package:electronicsrent/Screens/chat_page.dart';
//import 'package:electronicsrent/Screens/add_item_categories.dart';
import 'package:electronicsrent/Screens/home_screen.dart';
//import 'package:electronicsrent/Screens/price_dialog.dart';
//import 'package:electronicsrent/Screens/seller_category/seller_category.dart';
import 'package:flutter/material.dart';
//import 'package:electronicsrent/Screens/location_screen.dart';
//import 'package:electronicsrent/Screens/home_screen.dart';
//import 'package:location/location.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: const Color(0xFF40A858),
          body: IndexedStack(
            index: _pageIndex,
            children: [
              HomeScreen(),
              ChatPage(),
              ProductFormScreen(),
              CartScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            animationDuration: Duration(milliseconds: 300),
            items: [
              Icon(
                Icons.home,
                color: Colors.black,
              ),
              Icon(
                Icons.chat,
                color: Colors.black,
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, ProductFormScreen.id);
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              Icon(
                Icons.person,
                color: Colors.black,
              ),
            ],
            onTap: (value) {
              setState(() {
                _pageIndex = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
