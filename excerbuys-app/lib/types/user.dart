class User {
  final int id;
  final String username;
  final String email;
  final DateTime createdAt;
  final double points;
  final DateTime updatedAt;
  final String? image;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.createdAt,
      required this.points,
      required this.updatedAt,
      this.image});

  // Factory constructor to create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: int.parse(map['id']),
      username: map['username'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
      points: double.parse(map['points']), // Ensure double conversion
      updatedAt: DateTime.parse(map['updatedAt']),
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
      "updatedAt": "${updatedAt.toString()}",
      "points": "$points",
      "image": "$image"
    }""";
  }
}
