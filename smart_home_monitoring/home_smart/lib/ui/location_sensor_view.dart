// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:home_smart/sensors/location_sensor_manager.dart';

// class LocationSensorView extends StatefulWidget {
//   const LocationSensorView({Key? key}) : super(key: key);

//   @override
//   _LocationSensorViewState createState() => _LocationSensorViewState();
// }

// class _LocationSensorViewState extends State<LocationSensorView> {
//   final LocationSensorManager _locationSensorManager = LocationSensorManager();
//   String _permissionStatus = 'Checking permissions...';

//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//   }

//   @override
//   void dispose() {
//     _locationSensorManager.dispose();
//     super.dispose();
//   }

//   Future<void> _requestPermission() async {
//     bool permissionGranted = await _locationSensorManager.requestPermission();
//     setState(() {
//       _permissionStatus =
//           permissionGranted ? 'Permissions granted' : 'Permissions denied';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Position>(
//       stream: _locationSensorManager.locationStream,
//       builder: (context, snapshot) {
//         if (_permissionStatus != 'Permissions granted') {
//           return Center(child: Text(_permissionStatus));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text('Error occurred'));
//         }

//         final position = snapshot.data;

//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Latitude: ${position?.latitude ?? 'Unknown'}',
//                   style: const TextStyle(fontSize: 24)),
//               Text('Longitude: ${position?.longitude ?? 'Unknown'}',
//                   style: const TextStyle(fontSize: 24)),
//               // Add geofencing logic and visual indicators here
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:home_smart/notifications/notification_manager.dart';
import 'package:home_smart/sensors/location_sensor_manager.dart';

class LocationSensorView extends StatefulWidget {
  const LocationSensorView({Key? key}) : super(key: key);

  @override
  _LocationSensorViewState createState() => _LocationSensorViewState();
}

class _LocationSensorViewState extends State<LocationSensorView> {
  final LocationSensorManager _locationSensorManager = LocationSensorManager();
  final NotificationManager _notificationManager = NotificationManager();

  bool _isInsideGeofence = false;
  String _permissionStatus = 'Checking permissions...';
  @override
  void initState() {
    super.initState();
    _notificationManager.init();
    _requestPermission();
  }

  @override
  void dispose() {
    _locationSensorManager.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    bool permissionGranted = await _locationSensorManager.requestPermission();
    setState(() {
      _permissionStatus =
          permissionGranted ? 'Permissions granted' : 'Permissions denied';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: _locationSensorManager.locationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'));
        }

        final position = snapshot.data;

        bool isInsideGeofence =
            _locationSensorManager.isInsideGeofence(position!);

        if (isInsideGeofence != _isInsideGeofence) {
          _isInsideGeofence = isInsideGeofence;
          if (isInsideGeofence) {
            _notificationManager.showGeofenceEntryNotification();
          } else {
            _notificationManager.showGeofenceExitNotification();
          }
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${position.latitude}',
                  style: const TextStyle(fontSize: 24)),
              Text('Longitude: ${position.longitude}',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              Text(
                'Geofence Status: ${isInsideGeofence ? 'Inside' : 'Outside'}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
