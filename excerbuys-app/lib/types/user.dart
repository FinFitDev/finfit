class User {
  final int id;
  final String username;
  final String email;
  final DateTime createdAt;
  final double points;
  final DateTime stepsUpdatedAt;
  final String? image;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.createdAt,
      required this.points,
      required this.stepsUpdatedAt,
      this.image});

  // Factory constructor to create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: int.parse(map['id']),
      username: map['username'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
      points: double.parse(map['points']), // Ensure double conversion
      stepsUpdatedAt: DateTime.parse(map['stepsUpdatedAt']),
      image: map['image'], // image is nullable, so it can handle nulls
    );
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
      "image": "$image"
    }""";
  }

  User copyWith({
    int? id,
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
    );
  }
}
