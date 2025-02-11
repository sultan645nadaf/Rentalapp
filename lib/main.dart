import 'package:electronicsrent/Screens/ProfileScreen.dart';
import 'package:electronicsrent/Screens/add_item_categories.dart';
import 'package:electronicsrent/Screens/authentication_screen/auth.dart';
import 'package:electronicsrent/Screens/authentication_screen/phone_auth.dart';
import 'package:electronicsrent/Screens/cart_screen.dart';
import 'package:electronicsrent/Screens/categories/category_list.dart';
import 'package:electronicsrent/Screens/chat_page.dart';
import 'package:electronicsrent/Screens/home_screen.dart';
import 'package:electronicsrent/Screens/item_detail_screen.dart';
import 'package:electronicsrent/Screens/location_screen.dart';
import 'package:electronicsrent/Screens/login_register/login_screen.dart';
import 'package:electronicsrent/Screens/main_screen.dart';
import 'package:electronicsrent/Screens/models/cart_item.dart';
import 'package:electronicsrent/Screens/models/product.dart';
import 'package:electronicsrent/Screens/payment_screen.dart';
import 'package:electronicsrent/Screens/price_dialog.dart';
import 'package:electronicsrent/Screens/seller_category/seller_category.dart';
import 'package:electronicsrent/Screens/services/cart_service.dart';
import 'package:electronicsrent/Screens/splash.dart';
import 'package:electronicsrent/Screens/user_details_form_screen.dart';
import 'package:electronicsrent/Screens/services/database_service.dart';
import 'package:electronicsrent/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        Provider(create: (_) => DatabaseService()), // Provide DatabaseService
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColor: Colors.cyan.shade900, fontFamily: 'Lato'),
        initialRoute: SplashScreen.id,
        onGenerateRoute: (settings) {
          if (settings.name == ItemDetailScreen.id) {
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (context) {
                return ItemDetailScreen(product: product);
              },
            );
          } else if (settings.name == PaymentScreen.id) {
            final args = settings.arguments as Map<String, dynamic>;
            final amount = args['amount'] as double;
            final cartItem = args['cartItem'] as CartItem;
            return MaterialPageRoute(
              builder: (context) {
                return PaymentScreen(amount: amount, cartItem: cartItem);
              },
            );
          }
          return null;
        },
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          PhoneAuth.id: (context) => PhoneAuth(),
          LocationScreen.id: (context) => LocationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AuthPage.id: (context) => AuthPage(),
          CategoryList.id: (context) => CategoryList(),
          MainScreen.id: (context) => MainScreen(),
          SellerCategoryScreen.id: (context) => SellerCategoryScreen(),
          PriceDialog.id: (context) => PriceDialog(),
          ProductFormScreen.id: (context) => ProductFormScreen(),
          UserDetailsScreen.id: (context) => UserDetailsScreen(),
          CartScreen.id: (context) => CartScreen(),
          ChatPage.id: (context) => ChatPage(),
          ProfileScreen.id: (context) => ProfileScreen(),
        },
      ),
    );
  }
}
