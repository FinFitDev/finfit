import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:flutter/material.dart';

ActivityMetadata getActivityMetadata(
    ACTIVITY_TYPE activity, ColorScheme colors) {
  switch (activity) {
    case ACTIVITY_TYPE.Walk:
      return ActivityMetadata(
          icon: 'assets/svg/walking.svg',
          name: activity.label,
          color: colors.secondary);

    /// RUNNING
    case ACTIVITY_TYPE.Run:
    case ACTIVITY_TYPE.TrailRun:
    case ACTIVITY_TYPE.VirtualRun:
      return ActivityMetadata(
          icon: 'assets/svg/footprints.svg',
          name: activity.label,
          color: const Color.fromARGB(255, 255, 102, 7));

    /// CYCLING
    case ACTIVITY_TYPE.Ride:
    case ACTIVITY_TYPE.GravelRide:
    case ACTIVITY_TYPE.EBikeRide:
    case ACTIVITY_TYPE.EMountainBikeRide:
    case ACTIVITY_TYPE.MountainBikeRide:
    case ACTIVITY_TYPE.VirtualRide:
    case ACTIVITY_TYPE.Velomobile:
    case ACTIVITY_TYPE.Handcycle:
      return ActivityMetadata(
          icon: 'assets/svg/bike.svg',
          name: activity.label,
          color: colors.secondaryContainer);

    ///  WATER SPORTS
    case ACTIVITY_TYPE.Swim:
    case ACTIVITY_TYPE.Rowing:
    case ACTIVITY_TYPE.StandUpPaddling:
    case ACTIVITY_TYPE.Kayaking:
    case ACTIVITY_TYPE.Canoeing:
      return ActivityMetadata(
          icon: 'assets/svg/swimming.svg',
          name: activity.label,
          color: const Color.fromARGB(255, 102, 207, 255));

    /// WINTER SPORTS
    case ACTIVITY_TYPE.AlpineSki:
    case ACTIVITY_TYPE.BackcountrySki:
    case ACTIVITY_TYPE.NordicSki:
    case ACTIVITY_TYPE.Snowboard:
    case ACTIVITY_TYPE.Snowshoe:
    case ACTIVITY_TYPE.IceSkate:
    case ACTIVITY_TYPE.InlineSkate:
    case ACTIVITY_TYPE.RollerSki:
      return ActivityMetadata(
          icon: 'assets/svg/snowflake.svg',
          name: activity.label,
          color: const Color.fromARGB(255, 102, 207, 255));

    case ACTIVITY_TYPE.Other:
    default:
      return ActivityMetadata(
          icon: 'assets/svg/question.svg',
          name: activity.label,
          color: colors.tertiaryContainer);
  }
}
