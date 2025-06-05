import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

// TODO add all activities
ActivityMetadata getActivityMetadata(ACTIVITY_TYPE activity) {
  switch (activity) {
    case ACTIVITY_TYPE.WALKING:
      return ActivityMetadata(
          icon: 'assets/svg/walking.svg',
          name: 'Walking',
          color: const Color.fromARGB(255, 70, 24, 105));
    case ACTIVITY_TYPE.RUNNING:
      return ActivityMetadata(
          icon: 'assets/svg/running.svg',
          name: 'Running',
          color: Color.fromARGB(255, 0, 0, 0));
    case ACTIVITY_TYPE.BIKE_RIDING:
      return ActivityMetadata(
          icon: 'assets/svg/bike.svg',
          name: 'Bike riding',
          color: Color.fromARGB(255, 126, 126, 126));
    case ACTIVITY_TYPE.SWIMMING:
      return ActivityMetadata(
          icon: 'assets/svg/swimming.svg',
          name: 'Swimming',
          color: Color(0xFF6CB4EE));
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
    case HealthWorkoutActivityType.BIKING:
      return ACTIVITY_TYPE.BIKE_RIDING;
    default:
      return ACTIVITY_TYPE.WALKING;
  }
}
