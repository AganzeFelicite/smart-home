//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_smart/sensors/light_sensor_manager.dart';

import 'package:screen_brightness/screen_brightness.dart';

class LightSensorView extends StatefulWidget {
  const LightSensorView({Key? key}) : super(key: key);

  @override
  _LightSensorViewState createState() => _LightSensorViewState();
}

class _LightSensorViewState extends State<LightSensorView> {
  final LightSensorManager _lightSensorManager = LightSensorManager();
  double _currentLightLevel = 0.0;
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  @override
  void initState() {
    super.initState();
    _initSensor();
  }

  @override
  void dispose() {
    _lightSensorManager.dispose();
    super.dispose();
  }

  Future<void> _initSensor() async {
    try {
      // Platform-specific code to start listening to ambient light sensor data
      // _lightSensorManager.startListening();
      _lightSensorManager.lightLevelStream.listen((lightLevel) {
        setState(() {
          _currentLightLevel = lightLevel;
        });
        _adjustScreenBrightness(lightLevel);
      });
    } on PlatformException catch (e) {
      print("Failed to initialize ambient light sensor: '${e.message}'.");
    }
  }

  void _adjustScreenBrightness(double lightLevel) {
    try {
      // Adjust screen brightness based on light level
      _screenBrightness.setScreenBrightness(
          lightLevel / 100); // Scale light level to 0-1 range
    } on PlatformException catch (e) {
      // Handle PlatformException
      print("Failed to set screen brightness: ${e.message}");
      // You can show a snackbar, toast, or any other UI feedback to inform the user about the failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Slider(
          value: _currentLightLevel,
          min: 0,
          max: 100,
          onChanged: (newValue) {
            // You can optionally allow users to manually adjust the light level using the slider
            _adjustScreenBrightness(newValue);
          },
        ),
        SizedBox(height: 20),
        Text('Light Level: $_currentLightLevel lx'),
      ],
    );
  }
}
