import 'dart:convert';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/user/utils.dart';

class User {
  final String uuid;
  final String username;
  final String email;
  final DateTime? createdAt;
  final double? points;
  final String? image;
  final bool? verified;
  final double? totalPointsEarned;

  User(
      {required this.uuid,
      required this.username,
      required this.email,
      required this.createdAt,
      required this.points,
      String? image,
      this.verified,
      this.totalPointsEarned})
      : image = image == 'NULL' ? null : image;

  // Factory constructor to create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    final String? image = map['image'] == 'NULL' ? null : map['image'];
    final bool? verified = map['verified'] == 'NULL'
        ? null
        : bool.tryParse(map['verified'].toString() ?? 'false');
    return User(
        uuid: map['uuid'],
        username: map['username'],
        email: map['email'],
        createdAt: DateTime.parse(map['createdAt']),
        points: double.parse(map['points']), // Ensure double conversion
        image: image,
        verified: verified,
        totalPointsEarned: double.parse(map['total_points_earned']));
  }

  @override
  String toString() {
    return """{
      "uuid": "$uuid",
      "username": "$username",
      "email": "$email",
      "createdAt": "${createdAt.toString()}",
      "points": "$points",
      "image": "$image",
      "verified":"$verified",
      "total_points_earned":"$totalPointsEarned" 
    }""";
  }

  Map<String, dynamic> toMap() {
    return {
      "uuid": uuid,
      "username": username,
      "email": email,
      "createdAt": createdAt?.toIso8601String(),
      "points": points.toString(),
      "image": image,
      'verified': verified,
      "total_points_earned": totalPointsEarned.toString()
    };
  }

  User copyWith(
      {String? uuid,
      String? username,
      String? email,
      DateTime? createdAt,
      double? points,
      DateTime? stepsUpdatedAt,
      String? image,
      double? totalPointsEarned}) {
    return User(
        uuid: uuid ?? this.uuid,
        username: username ?? this.username,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        points: points ?? this.points,
        image: image ?? this.image,
        verified: verified ?? this.verified,
        totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uuid: json['uuid'],
        points: parseInt(json['points'] ?? '0').toDouble(),
        username: json['username'],
        email: json['email'],
        image: json['image'],
        createdAt: dateTimeParseNullish(json['created_at']),
        verified: json['verified'],
        totalPointsEarned:
            parseInt(json['total_points_earned'] ?? '0').toDouble());
  }
}

class UserItem {
  final User user;
  final DateTime timestamp;

  const UserItem({required this.user, required this.timestamp});

  @override
  String toString() {
    return jsonEncode({
      "user": user.toMap(), // ✅ Convert to Map before encoding
      "timestamp": timestamp.toIso8601String(), // ✅ Store in ISO format
    });
  }

  static UserItem fromMap(Map<String, dynamic> map) {
    return UserItem(
      user: User.fromMap(map["user"]),
      timestamp: DateTime.parse(map["timestamp"]),
    );
  }
}

class UserToVerify {
  final String login;
  final String password;
  final String userId;

  const UserToVerify(
      {required this.userId, required this.login, required this.password});
}

class ResetPasswordUser {
  final String email;
  final String userId;

  const ResetPasswordUser({required this.email, required this.userId});
}
