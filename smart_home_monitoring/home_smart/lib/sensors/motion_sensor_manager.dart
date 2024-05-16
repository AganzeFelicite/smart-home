import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionSensorManager {
  bool _isMotionDetected = false;

  // Expose a stream of boolean values indicating motion detection
  Stream<bool> get motionDetectionStream => accelerometerEventStream()
      .map((event) => _detectMotion(event.x, event.y, event.z))
      .distinct();

  bool get isMotionDetected => _isMotionDetected;

  bool _detectMotion(double x, double y, double z) {
    // Implement your motion detection algorithm here
    // Example: Detect if the acceleration values exceed a certain threshold
    const threshold = 1.0; // Adjust this value as needed
    if (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold) {
      _isMotionDetected = true;
      return true;
    }
    _isMotionDetected = false;
    return false;
  }

  void dispose() {
    // No need to manually stop the accelerometerEventStream
    // The sensors_plus package manages the lifecycle of the streams
  }
}
