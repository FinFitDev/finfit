import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart'
    as AndroidSettings;
import 'package:background_locator_2/settings/ios_settings.dart' as IOSSettings;
import 'package:background_locator_2/settings/locator_settings.dart'
    as LocatorSettings;
import 'package:excerbuys/handlers/location_callback_handler.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/gps/gps_tracker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WorkoutTrackingService {
  final ProfessionalGPSTracker _gpsTracker = ProfessionalGPSTracker();
  final List<Position> _workoutPositions = [];
  StreamSubscription<Position>? _positionStream;
  ReceivePort port = ReceivePort();

  void Function(Position)? onPositionUpdate;

  Future<bool> init({int distance = 2}) async {
    if (!await requestPermissions()) return false;
    port = ReceivePort();

    IsolateNameServer.removePortNameMapping(
        LocationCallbackHandler.isolateName);
    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationCallbackHandler.isolateName);

    port.listen((dynamic data) {
      if (data is Map) {
        final position = Position(
          latitude: data['latitude'],
          longitude: data['longitude'],
          timestamp: DateTime.now(),
          accuracy: data['accuracy'],
          altitude: data['altitude'],
          heading: data['heading'],
          speed: data['speed'],
          speedAccuracy: data['speedAccuracy'],
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        _handlePositionUpdate(position);
      }
    });

    // 🆕 Initialize Background Locator
    await BackgroundLocator.initialize();
    await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      disposeCallback: LocationCallbackHandler.disposeCallback,
      iosSettings: IOSSettings.IOSSettings(
        accuracy: LocatorSettings.LocationAccuracy.NAVIGATION,
        distanceFilter: distance.toDouble(),
      ),
      autoStop: false,
      androidSettings: AndroidSettings.AndroidSettings(
        accuracy: LocatorSettings.LocationAccuracy.NAVIGATION,
        interval: 1000,
        distanceFilter: distance.toDouble(),
        client: AndroidSettings.LocationClient.google,
        androidNotificationSettings:
            AndroidSettings.AndroidNotificationSettings(
          notificationChannelName: 'Workout Tracking',
          notificationTitle: 'Workout in progress',
          notificationMsg: 'Tracking your workout...',
          notificationIcon: '',
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );

    try {
      final initialPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      onPositionUpdate?.call(initialPosition);
    } catch (e) {
      print('Error getting initial position: $e');
    }

    return true;
  }

  void updateDistanceInterval(int distance) async {
    await BackgroundLocator.unRegisterLocationUpdate();
    init(distance: distance);
  }

  void dispose() async {
    print('DISPOSED');
    await BackgroundLocator.unRegisterLocationUpdate();
    IsolateNameServer.removePortNameMapping(
        LocationCallbackHandler.isolateName);
    _gpsTracker.reset();
    _workoutPositions.clear();
  }

  void _handlePositionUpdate(Position rawPosition) {
    final finalPosition = _gpsTracker.processPosition(rawPosition);

    if (finalPosition != null) {
      _workoutPositions.add(finalPosition);
      onPositionUpdate?.call(finalPosition);
    }
  }

  LocationSettings _getLocationSettings(int distance) {
    return LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: distance,
    );
  }

  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied by user');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied');
      return false;
    }

    if (permission == LocationPermission.whileInUse) {
      print('Only foreground permission granted. Requesting background...');

      return false;
    }
    print('Background location permission granted');
    return true;
  }

  List<Position> get currentPositions => List.from(_workoutPositions);
  int get positionCount => _workoutPositions.length;
}
