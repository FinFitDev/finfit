import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/home/utils.dart';

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
