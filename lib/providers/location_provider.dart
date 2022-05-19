import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  double? _longitude;
  double? _latitude;
  double? get longitude => _longitude;
  double? get latitude => _latitude;
  LocationData? _locationData;
  LocationData? get locationData {
    return _locationData;
  }

  Future<void> getCurrentLocation() async {
    //using location package
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //GETTING CURRENT LOCATION OF USER

    _locationData = await location.getLocation();

    notifyListeners();
  }

  void propertyLocation(double longitude, double latitude) {
    _longitude = longitude;
    _latitude = latitude;

    notifyListeners();
  }

  void clearLocation() {
    _longitude = null;
    _latitude = null;
    notifyListeners();
  }
}
