import 'package:location/location.dart';

class CustomLiveLocation {
  static LocationData? currentLocation;

  static getLiveLocation() async {
    Location location = new Location();
    location.changeSettings(
      interval: 120000,
    );
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    // LocationData _locationData;

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
    CustomLiveLocation.currentLocation = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      CustomLiveLocation.currentLocation = currentLocation;
    });
  }
}
