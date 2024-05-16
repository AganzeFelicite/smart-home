import 'package:geolocator/geolocator.dart';

class LocationSensorManager {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  Position? _currentPosition;

  // Define the geofence area (e.g., your home)
  final double homeLatitude = 37.7749; // Replace with your desired latitude
  final double homeLongitude = -122.4194; // Replace with your desired longitude
  final double geofenceRadius = 100.0; // Radius in meters

  Stream<Position> get locationStream =>
      _geolocatorPlatform.getPositionStream();

  Position? get currentPosition => _currentPosition;

  Future<bool> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }
    }

    return true;
  }

  void dispose() {}

  bool isInsideGeofence(Position position) {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      homeLatitude,
      homeLongitude,
    );

    return distance <= geofenceRadius;
  }
}
