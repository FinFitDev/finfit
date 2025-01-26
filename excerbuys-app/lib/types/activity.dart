import 'package:excerbuys/types/general.dart';

enum STEPS_AGGREGATION_TYPE { HOURLY, DAILY, MONTHLY }

enum STEPS_AGGREGATION_VALUE { TOTAL, MEAN }

enum ACTIVITY_TYPE { WALKING, RUNNING, BIKE_RIDING, SWIMMING }

class ActivityMetadata {
  final String icon;
  final String name;

  const ActivityMetadata({required this.icon, required this.name});
}

class ITrainingEntry {
  final String uuid;
  final int points;
  final String type;
  final int userId;
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
        "uuid":"${this.uuid}",
        "points":"${this.points}",
        "type":"${this.type}",
        "user_id":"${this.userId}",
        "duration":"${this.duration}",
        "calories":"${this.calories}",
        "distance":"${this.distance}",
        "created_at":"${this.createdAt}"
      }""";
  }
}

class IHourlyStepsEntry {
  final int total;
  final int userId;
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
