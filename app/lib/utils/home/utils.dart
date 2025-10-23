import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

// TODO add all activities
ActivityMetadata getActivityMetadata(
    ACTIVITY_TYPE activity, ColorScheme colors) {
  switch (activity) {
    case ACTIVITY_TYPE.Walk:
      return ActivityMetadata(
          icon: 'assets/svg/walking.svg',
          name: 'Walking',
          color: colors.secondary);
    case ACTIVITY_TYPE.Run:
      return ActivityMetadata(
          icon: 'assets/svg/footprints.svg',
          name: 'Running',
          color: colors.secondary);
    case ACTIVITY_TYPE.Ride:
      return ActivityMetadata(
          icon: 'assets/svg/bike.svg',
          name: 'Bike riding',
          color: colors.secondaryContainer);
    case ACTIVITY_TYPE.Swim:
      return ActivityMetadata(
          icon: 'assets/svg/swimming.svg',
          name: 'Swimming',
          color: colors.secondaryContainer);
  }
}

ACTIVITY_TYPE parseActivityType(HealthWorkoutActivityType? type) {
  switch (type) {
    case HealthWorkoutActivityType.RUNNING:
    case HealthWorkoutActivityType.RUNNING_TREADMILL:
      return ACTIVITY_TYPE.Run;
    case HealthWorkoutActivityType.SWIMMING_POOL:
    case HealthWorkoutActivityType.SWIMMING:
    case HealthWorkoutActivityType.SWIMMING_OPEN_WATER:
      return ACTIVITY_TYPE.Swim;
    case HealthWorkoutActivityType.BIKING:
      return ACTIVITY_TYPE.Ride;
    default:
      return ACTIVITY_TYPE.Walk;
  }
}
