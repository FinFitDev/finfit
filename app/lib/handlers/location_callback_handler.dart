import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  int currentDistance = 2;
  StreamSubscription<Position>? _positionStream;

  void startStream(int distance) {
    _positionStream?.cancel();

    LocationSettings settings;
    if (Platform.isIOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: distance,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    } else {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: distance,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
      );
    }

    _positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position position) {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Workout in Progress",
          content:
              "GPS: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}",
        );
      }

      service.invoke('location_update', {
        'lat': position.latitude,
        'lng': position.longitude,
        'accuracy': position.accuracy,
        'alt': position.altitude,
        'heading': position.heading,
        'speed': position.speed,
        'speed_accuracy': position.speedAccuracy,
        'time': position.timestamp.toIso8601String(),
      });
    });
  }

  service.on('set_config').listen((event) {
    if (event != null && event.containsKey('distance')) {
      int newDistance = event['distance'] as int;
      print("Background: Setting distance filter to $newDistance");
      startStream(newDistance);
    }
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  startStream(currentDistance);
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
