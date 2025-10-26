import 'package:excerbuys/types/enums.dart';

class WorkoutType {
  final ACTIVITY_TYPE name;
  final String icon;

  // Constructor with required parameters
  WorkoutType({
    required this.name,
    required this.icon,
  });
}

List<ACTIVITY_TYPE> AVAILABLE_WORKOUT_TYPES = [
  ACTIVITY_TYPE.Run,
  ACTIVITY_TYPE.Walk,
  ACTIVITY_TYPE.Ride
];

Map<ACTIVITY_TYPE, int> TRACKING_DISTANCE_INTERVALS = {
  ACTIVITY_TYPE.Walk: 1,
  ACTIVITY_TYPE.Run: 2,
  ACTIVITY_TYPE.Ride: 3
};
