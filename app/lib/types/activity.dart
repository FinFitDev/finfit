import 'package:excerbuys/types/general.dart';
import 'package:flutter/material.dart';

enum STEPS_AGGREGATION_TYPE { HOURLY, DAILY, MONTHLY }

enum STEPS_AGGREGATION_VALUE { TOTAL, MEAN }

enum ACTIVITY_TYPE { WALKING, RUNNING, BIKE_RIDING, SWIMMING }

class ActivityMetadata {
  final String icon;
  final String name;
  final Color color;
  final Color? textColor;

  const ActivityMetadata(
      {required this.icon,
      required this.name,
      required this.color,
      this.textColor});
}

class ITrainingEntry {
  final String uuid;
  final int points;
  final String type;
  final String userId;
  final int duration;
  final DateTime createdAt;
  final int? calories;
  final int? distance;

  const ITrainingEntry(
      {required this.uuid,
      required this.points,
      required this.duration,
      this.calories,
      this.distance,
      required this.type,
      required this.userId,
      required this.createdAt});

  String toJson() {
    return """{
        "uuid":"${uuid}",
        "points":"${points}",
        "type":"${type}",
        "user_id":"${userId}",
        "duration":"${duration}",
        "calories":"${calories}",
        "distance":"${distance}",
        "created_at":"${createdAt}"
      }""";
  }
}

class IHourlyStepsEntry {
  final int total;
  final String userId;
  final DateTime timestamp;
  final String uuid;

  const IHourlyStepsEntry(
      {required this.uuid,
      required this.total,
      required this.userId,
      required this.timestamp});

  String toJson() {
    return """{
        "uuid":"$uuid",
        "timestamp":"$timestamp",
        "user_id":"$userId",
        "total":"$total"
      }""";
  }
}

typedef IStoreStepsData = Map<DateTime, Map<int, int>>;
