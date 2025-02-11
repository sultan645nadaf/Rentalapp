import 'package:electronicsrent/Screens/main_screen.dart';
import 'package:electronicsrent/Screens/services/location_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
//import 'location_service.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location_screen';

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  loc.Location location = loc.Location();
  bool _serviceEnabled = false;
  loc.PermissionStatus _permissionGranted = loc.PermissionStatus.denied;
  loc.LocationData? _locationData;
  String? _address;

  Future<void> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    setState(() {
      _locationData = locationData;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData!.latitude!,
        _locationData!.longitude!,
      );
      Placemark place = placemarks[0];
      setState(() {
        _address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}";
      });

      // Update the singleton with the new location data and address
      LocationService().updateLocation(_locationData!, _address!);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 35, right: 35),
            child: Image.asset('assets/images/location.jpg'),
          ),
          SizedBox(height: 10),
          Text(
            'Where do you want\n to buy/sell your products',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: 10),
          Text(
            'To enjoy all that we have to offer you\n we need to know where to look for them',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              icon: Icon(CupertinoIcons.location_fill),
              label: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text('Around me'),
              ),
              onPressed: () {
                progressDialog.show();
                getLocation().then((_) {
                  progressDialog.dismiss();
                  if (_locationData != null && _address != null) {
                    Navigator.pushReplacementNamed(context, MainScreen.id);
                  }
                });
              },
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              progressDialog.show();
              // Call the method to show the bottom sheet
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 2)),
                ),
                child: Text(
                  'Set location manually',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
