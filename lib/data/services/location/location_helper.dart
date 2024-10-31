import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.high, /* locationSettings: locationSettings */
    );
  }

  static Future<List<double>> getLatitudeAndLongitude() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.high, /* locationSettings: locationSettings */
    );

    return [position.latitude, position.longitude];
  }

  static Future<bool> checkLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    if (permission == LocationPermission.denied) {
      return false;
    }

    return true;
  }

  static Future<bool> checkServiceLocation() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    } else {
      return true;
    }
  }

  static settingLocation() async {
    await Geolocator.openAppSettings();
  }

  static settingServiceLocation() async {
    await Geolocator.openLocationSettings();
  }
}
