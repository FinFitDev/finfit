import 'package:excerbuys/types/activity.dart';
import 'package:health/health.dart';

ActivityMetadata getActivityMetadata(ACTIVITY_TYPE activity) {
  switch (activity) {
    case ACTIVITY_TYPE.WALKING:
      return ActivityMetadata(icon: 'assets/svg/walking.svg', name: 'Walking');
    case ACTIVITY_TYPE.RUNNING:
      return ActivityMetadata(icon: 'assets/svg/running.svg', name: 'Running');
    case ACTIVITY_TYPE.BIKE_RIDING:
      return ActivityMetadata(icon: 'assets/svg/bike.svg', name: 'Bike riding');
    case ACTIVITY_TYPE.SWIMMING:
      return ActivityMetadata(
          icon: 'assets/svg/swimming.svg', name: 'Swimming');
  }
}

ACTIVITY_TYPE parseActivityType(HealthWorkoutActivityType? type) {
  switch (type) {
    case HealthWorkoutActivityType.RUNNING:
    case HealthWorkoutActivityType.RUNNING_TREADMILL:
      return ACTIVITY_TYPE.RUNNING;
    case HealthWorkoutActivityType.SWIMMING_POOL:
    case HealthWorkoutActivityType.SWIMMING:
    case HealthWorkoutActivityType.SWIMMING_OPEN_WATER:
      return ACTIVITY_TYPE.SWIMMING;
    default:
      return ACTIVITY_TYPE.WALKING;
  }
}
