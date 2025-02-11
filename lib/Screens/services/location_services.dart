import 'package:location/location.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  LocationData? locationData;
  String? address;

  void updateLocation(LocationData newLocationData, String newAddress) {
    locationData = newLocationData;
    address = newAddress;
  }
}
