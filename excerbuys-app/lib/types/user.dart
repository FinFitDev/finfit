import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String email;
  final DateTime createdAt;
  final double points;
  final DateTime stepsUpdatedAt;
  final String? image;
  final bool? verified;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.createdAt,
      required this.points,
      required this.stepsUpdatedAt,
      String? image,
      this.verified})
      : image = image == 'NULL' ? null : image;

  // Factory constructor to create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    final String? image = map['image'] == 'NULL' ? null : map['image'];
    final bool? verified = map['verified'] == 'NULL'
        ? null
        : bool.parse(map['verified'] ?? 'false');
    return User(
        id: map['id'],
        username: map['username'],
        email: map['email'],
        createdAt: DateTime.parse(map['createdAt']),
        points: double.parse(map['points']), // Ensure double conversion
        stepsUpdatedAt: DateTime.parse(map['stepsUpdatedAt']),
        image: image,
        verified: verified);
  }

  @override
  String toString() {
    return """{
      "id": "$id",
      "username": "$username",
      "email": "$email",
      "createdAt": "${createdAt.toString()}",
      "stepsUpdatedAt": "${stepsUpdatedAt.toString()}",
      "points": "$points",
      "image": "$image",
      "verified":"$verified"
    }""";
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "createdAt": createdAt.toIso8601String(),
      "stepsUpdatedAt": stepsUpdatedAt.toIso8601String(),
      "points": points.toString(),
      "image": image,
      'verified': verified
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    DateTime? createdAt,
    double? points,
    DateTime? stepsUpdatedAt,
    String? image,
  }) {
    return User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        points: points ?? this.points,
        stepsUpdatedAt: stepsUpdatedAt ?? this.stepsUpdatedAt,
        image: image ?? this.image,
        verified: verified ?? this.verified);
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

// used for profile image generation
class ShapeModel {
  final Color color;
  final double x;
  final double y;
  final double w;
  final double h;
  final double angle;
  final CustomPainter Function(Color, double, double, double, double, double)
      painter;

  ShapeModel({
    required this.color,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.angle,
    required this.painter,
  });
}
