import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:electronicsrent/Screens/login_register/login_screen.dart';
import 'package:electronicsrent/Screens/location_screen.dart';
import 'package:electronicsrent/Screens/services/location_services.dart';
//import 'package:electronicsrent/Services/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        _checkAuthAndNavigate();
      },
    );
  }

  void _checkAuthAndNavigate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } else {
      loc.Location location = loc.Location();
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }

      loc.PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }

      loc.LocationData _locationData = await location.getLocation();

      // Get address from coordinates
      String address = await _getAddressFromCoordinates(
          _locationData.latitude!, _locationData.longitude!);

      // Update the singleton with the new location data and address
      LocationService().updateLocation(_locationData, address);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LocationScreen()),
      );
    }
  }

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    geo.Placemark place = placemarks[0];
    return "${place.locality}, ${place.administrativeArea}, ${place.country}";
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.grey,
      Colors.white,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Horizon',
    );

    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/images.png',
            ),
            SizedBox(
              height: 10,
            ),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Buy or Sell',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),
          ],
        ),
      ),
    );
  }
}