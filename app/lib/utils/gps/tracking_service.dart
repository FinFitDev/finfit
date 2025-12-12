import 'dart:async';
import 'package:excerbuys/handlers/location_callback_handler.dart';
import 'package:excerbuys/utils/gps/gps_tracker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkoutTrackingService {
  final ProfessionalGPSTracker _gpsTracker = ProfessionalGPSTracker();
  final List<Position> _workoutPositions = [];

  final FlutterBackgroundService _service = FlutterBackgroundService();
  StreamSubscription? _serviceSubscription;

  // used when not tracking
  StreamSubscription<Position>? _idleLocationSubscription;

  void Function(Position)? onPositionUpdate;

  bool _isTracking = false;
  bool _isInitialized = false;
  String? _notificationTitle;
  String? _notificationContent;

// run only once - dont start yet
  Future<bool> initializeService(AppLocalizations l10n) async {
    if (!_isInitialized) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const channelId = 'workout_tracking';

      _notificationTitle = l10n.textWorkoutTrackingNotificationTitle;
      _notificationContent = l10n.textWorkoutTrackingNotificationContent;

      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        l10n.textWorkoutTrackingChannelName,
        description: l10n.textWorkoutTrackingChannelDescription,
        importance: Importance.low,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await _service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId: channelId,
          initialNotificationTitle:
              _notificationTitle ?? 'Workout in progress...',
          initialNotificationContent:
              _notificationContent ?? 'Tracking your workout...',
          foregroundServiceNotificationId: 888,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );

      _isInitialized = true;
    }

    if (!await requestPermissions()) return false;

    await startIdleListening();
    return true;
  }

  Future<void> startIdleListening() async {
    if (_isTracking) return;

    if (!await requestPermissions()) return;

    await _idleLocationSubscription?.cancel();

    print("Starting IDLE location listener");
    _idleLocationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
      ),
    ).listen((Position position) {
      onPositionUpdate?.call(position);
    });
  }

  Future<void> stopIdleListening() async {
    await _idleLocationSubscription?.cancel();
    _idleLocationSubscription = null;
  }

  /// Starts the workout tracking (runs in background).
  Future<bool> startTracking({int distance = 2}) async {
    if (!await requestPermissions()) return false;

    await stopIdleListening();
    _workoutPositions.clear();
    _gpsTracker.reset();
    _isTracking = true;

    if (!await _service.isRunning()) {
      await _service.startService();
    }

    _service.invoke('set_config', {'distance': distance});

    _serviceSubscription?.cancel();
    _serviceSubscription = _service.on('location_update').listen((event) {
      if (event != null) {
        _parseAndProcessLocation(event);
      }
    });

    try {
      final initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _handlePositionUpdate(initialPosition);
    } catch (e) {
      print('Error getting initial position: $e');
    }

    return true;
  }

  /// Stops the workout tracking.
  Future<void> stopTracking() async {
    print('STOPPING TRACKING');

    _isTracking = false;
    _service.invoke('stopService');
    await _serviceSubscription?.cancel();
    _gpsTracker.reset();

    await startIdleListening();
  }

  /// Helper to parse the raw Map data from background service back into a Position object
  void _parseAndProcessLocation(Map<String, dynamic> data) {
    print(data);
    try {
      final position = Position(
        latitude: double.tryParse(data['lat'].toString()) ?? 0.0,
        longitude: double.tryParse(data['lng'].toString()) ?? 0.0,
        timestamp: DateTime.parse(data['time']),
        accuracy: double.tryParse(data['accuracy'].toString()) ?? 0.0,
        altitude: double.tryParse(data['alt'].toString()) ?? 0.0,
        heading: double.tryParse(data['heading'].toString()) ?? 0.0,
        speed: double.tryParse(data['speed'].toString()) ?? 0.0,
        speedAccuracy:
            double.tryParse(data['speed_accuracy'].toString()) ?? 0.0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
      _handlePositionUpdate(position);
    } catch (e) {
      print("Error parsing location data: $e");
    }
  }

  void _handlePositionUpdate(Position rawPosition) {
    final finalPosition = _gpsTracker.processPosition(rawPosition);

    if (finalPosition != null) {
      _workoutPositions.add(finalPosition);
      onPositionUpdate?.call(finalPosition);
    }
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

    return true;
  }

  void dispose() {
    print('DISPOSE');

    _service.invoke('stopService');
    _serviceSubscription?.cancel();
    _gpsTracker.reset();
    _idleLocationSubscription?.cancel();
  }
}
