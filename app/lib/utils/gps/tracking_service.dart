import 'dart:async';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/gps/gps_tracker.dart';
import 'package:geolocator/geolocator.dart';

class WorkoutTrackingService {
  final ProfessionalGPSTracker _gpsTracker = ProfessionalGPSTracker();
  final List<Position> _workoutPositions = [];
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  void Function(Position)? onPositionUpdate;

  void init() async {
    if (!await _requestPermissions()) {
      return;
    }
    try {
      final initialPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      smartPrint('INITISAL', initialPosition);
      onPositionUpdate?.call(initialPosition);
    } catch (e) {
      print('Error getting initial position: $e');
    }
    _positionStream = Geolocator.getPositionStream(
      locationSettings: _getLocationSettings(1),
    ).listen(_handlePositionUpdate);
  }

  void updateDistanceInterval(int distance) {
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: _getLocationSettings(distance),
    ).listen(_handlePositionUpdate);
  }

  void dispose() async {
    print('DISPOSED');
    await _positionStream?.cancel();
    _gpsTracker.reset();
    _workoutPositions.clear();
  }

  void _handlePositionUpdate(Position rawPosition) {
    smartPrint('RAW', rawPosition);

    final finalPosition = _gpsTracker.processPosition(rawPosition);

    smartPrint('PROCESSED', finalPosition);

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

  Future<bool> _requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions permanently denied');
      return false;
    }

    return true;
  }

  // Getters
  bool get isTracking => _isTracking;
  List<Position> get currentPositions => List.from(_workoutPositions);
  int get positionCount => _workoutPositions.length;
}
