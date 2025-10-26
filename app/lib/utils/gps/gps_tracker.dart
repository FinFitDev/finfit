import 'dart:math';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:geolocator/geolocator.dart';

class ProfessionalGPSTracker {
  static const double MAX_REALISTIC_SPEED = 16.0;
  static const double MAX_ACCEPTABLE_ACCURACY = 25.0;
  static const double MIN_ACCEPTABLE_ACCURACY = 3.0;
  static const int SPEED_BUFFER_SIZE = 3;
  static const int MOVING_AVERAGE_BUFFER_SIZE = 5;

  // State tracking
  Position? _lastValidPosition;
  DateTime? _lastUpdateTime;
  final List<double> _speedBuffer = [];
  final List<Position> _positionBuffer = []; // For moving average
  int _consecutiveRejects = 0;
  int _totalProcessed = 0;
  int _totalRejected = 0;

  ProfessionalGPSTracker();

  Position? processPosition(Position newPosition) {
    _totalProcessed++;

    if (!_isPositionValid(newPosition)) {
      print('POSITION INVALID');
      _consecutiveRejects++;
      _totalRejected++;
      return null;
    }

    if (!_passesSpeedTest(newPosition)) {
      print('SPEED ISSUE');
      _consecutiveRejects++;
      _totalRejected++;
      return null;
    }

    final smoothedPosition = _applyMovingAverage(newPosition);

    _lastValidPosition = smoothedPosition;
    _lastUpdateTime = DateTime.now();
    _consecutiveRejects = 0;

    // if (_totalProcessed % 10 == 0) {
    //   print('GPS Stats: Processed: $_totalProcessed, Rejected: $_totalRejected '
    //       '(${(_totalRejected / _totalProcessed * 100).toStringAsFixed(1)}%)');
    // }

    return smoothedPosition;
  }

  Position _applyMovingAverage(Position newPosition) {
    _positionBuffer.add(newPosition);

    if (_positionBuffer.length > MOVING_AVERAGE_BUFFER_SIZE) {
      _positionBuffer.removeAt(0);
    }

    if (_positionBuffer.length < 2) {
      return newPosition;
    }

    double totalWeight = 0;
    double weightedLat = 0;
    double weightedLon = 0;
    double? weightedAltitude;
    double? weightedAccuracy;
    double? weightedSpeed;

    for (int i = 0; i < _positionBuffer.length; i++) {
      final weight = (i + 1).toDouble();
      final position = _positionBuffer[i];

      weightedLat += position.latitude * weight;
      weightedLon += position.longitude * weight;

      weightedAltitude = (weightedAltitude ?? 0) + position.altitude * weight;

      weightedAccuracy = (weightedAccuracy ?? 0) + position.accuracy * weight;

      weightedSpeed = (weightedSpeed ?? 0) + position.speed * weight;

      totalWeight += weight;
    }

    return Position(
      longitude: weightedLon / totalWeight,
      latitude: weightedLat / totalWeight,
      timestamp: newPosition.timestamp,
      altitude: weightedAltitude! / totalWeight,
      accuracy: weightedAccuracy! / totalWeight,
      altitudeAccuracy: newPosition.altitudeAccuracy,
      heading: newPosition.heading,
      headingAccuracy: newPosition.headingAccuracy,
      speed: weightedSpeed! / totalWeight,
      speedAccuracy: newPosition.speedAccuracy,
    );
  }

  bool _isPositionValid(Position position) {
    // Accuracy check - reject poor quality signals
    if (position.accuracy > MAX_ACCEPTABLE_ACCURACY) {
      return false;
    }

    // Reject suspiciously high accuracy (often GPS errors)
    if (position.accuracy < MIN_ACCEPTABLE_ACCURACY) {
      return false;
    }

    // Check for valid coordinates
    if (position.latitude.abs() > 90 || position.longitude.abs() > 180) {
      return false;
    }

    // Check for zero coordinates (common GPS error)
    if (position.latitude == 0.0 && position.longitude == 0.0) {
      return false;
    }

    return true;
  }

  bool _passesSpeedTest(Position newPosition) {
    if (_lastValidPosition == null || _lastUpdateTime == null) {
      return true;
    }

    final timeDiff =
        newPosition.timestamp.difference(_lastUpdateTime!).inSeconds;

    if (timeDiff <= 0) {
      return true;
    }

    // Calculate distance between last valid position and new position
    final distance = calculateHaversineDistance(
      _lastValidPosition!.latitude,
      _lastValidPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    final instantSpeed = distance / timeDiff;

    _speedBuffer.add(instantSpeed);
    if (_speedBuffer.length > SPEED_BUFFER_SIZE) {
      _speedBuffer.removeAt(0);
    }

    if (instantSpeed > MAX_REALISTIC_SPEED * 2.0) {
      print(
          'Rejected: Impossible speed ${instantSpeed.toStringAsFixed(1)} m/s');
      return false;
    }

    if (_speedBuffer.length >= 2) {
      final currentSpeed = _speedBuffer.last;
      final previousSpeed = _speedBuffer[_speedBuffer.length - 2];
      final acceleration = (currentSpeed - previousSpeed).abs() / timeDiff;

      if (acceleration > 10.0) {
        print(
            'Rejected: Extreme acceleration ${acceleration.toStringAsFixed(1)} m/s²');
        return false;
      }
    }

    if (_consecutiveRejects > 5) {
      print(
          'Multiple consecutive rejects, accepting position with speed ${instantSpeed.toStringAsFixed(1)} m/s');
      return true;
    }

    return true;
  }

  /// Reset the tracker for a new workout
  void reset() {
    _lastValidPosition = null;
    _lastUpdateTime = null;
    _speedBuffer.clear();
    _positionBuffer.clear();
    _consecutiveRejects = 0;
    _totalProcessed = 0;
    _totalRejected = 0;
  }

  Map<String, dynamic> getStats() {
    return {
      'totalProcessed': _totalProcessed,
      'totalRejected': _totalRejected,
      'rejectionRate':
          _totalProcessed > 0 ? (_totalRejected / _totalProcessed * 100) : 0,
      'consecutiveRejects': _consecutiveRejects,
      'bufferSize': _positionBuffer.length,
    };
  }
}
