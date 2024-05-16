// import 'package:flutter/material.dart';
// import 'package:home_smart/sensors/motion_sensor_manager.dart';

// class MotionSensorView extends StatefulWidget {
//   const MotionSensorView({Key? key}) : super(key: key);

//   @override
//   _MotionSensorViewState createState() => _MotionSensorViewState();
// }

// class _MotionSensorViewState extends State<MotionSensorView> {
//   final MotionSensorManager _motionSensorManager = MotionSensorManager();

//   @override
//   void dispose() {
//     _motionSensorManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<bool>(
//       stream: _motionSensorManager.motionDetectionStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text('Error occurred'));
//         }

//         final isMotionDetected = snapshot.data ?? false;

//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 isMotionDetected ? 'Motion Detected' : 'No Motion',
//                 style: const TextStyle(fontSize: 24),
//               ),
//               // Add visual indicators or actions here
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:home_smart/notifications/notification_manager.dart';

import 'package:home_smart/sensors/motion_sensor_manager.dart';

class MotionSensorView extends StatefulWidget {
  const MotionSensorView({Key? key}) : super(key: key);

  @override
  _MotionSensorViewState createState() => _MotionSensorViewState();
}

class _MotionSensorViewState extends State<MotionSensorView> {
  final MotionSensorManager _motionSensorManager = MotionSensorManager();
  final NotificationManager _notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    _notificationManager.init();
  }

  @override
  void dispose() {
    _motionSensorManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _motionSensorManager.motionDetectionStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'));
        }

        final isMotionDetected = snapshot.data ?? false;

        if (isMotionDetected) {
          _notificationManager.showMotionDetectedNotification();
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isMotionDetected ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isMotionDetected ? 'Motion Detected' : 'No Motion',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        );
      },
    );
  }
}
