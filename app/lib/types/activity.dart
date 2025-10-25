import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';

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
  final int id;
  final int points;
  final ACTIVITY_TYPE type;
  final String userId;
  final int duration;
  final DateTime createdAt;
  final int? calories;
  final int? distance;
  final int? stravaId;
  final String? polyline;
  final double? elevationChange;
  final double? averageSpeed;

  const ITrainingEntry({
    required this.id,
    required this.points,
    required this.duration,
    required this.type,
    required this.userId,
    required this.createdAt,
    this.calories,
    this.distance,
    this.stravaId,
    this.polyline,
    this.elevationChange,
    this.averageSpeed,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "points": points,
      "type": type.value, // Convert enum to string
      "user_id": userId,
      "duration": duration,
      "calories": calories,
      "distance": distance,
      "strava_id": stravaId,
      "polyline": polyline,
      "elevation_change": elevationChange,
      "average_speed": averageSpeed,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory ITrainingEntry.fromJson(Map<String, dynamic> json) {
    return ITrainingEntry(
        id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
        points: json['points'] as int,
        type: ACTIVITY_TYPE
            .fromString(json['type'] as String), // Convert string to enum
        userId: json['user_id'] as String,
        duration: json['duration'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        calories: json['calories'] as int?,
        distance: json['distance'] as int?,
        stravaId: json['strava_id'] is String
            ? int.tryParse(json['strava_id'])
            : json['strava_id'] as int?,
        polyline: json['polyline'] as String?,
        elevationChange: safeParseDouble(json['elevation_change']),
        averageSpeed: safeParseDouble(json['average_speed']));
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
