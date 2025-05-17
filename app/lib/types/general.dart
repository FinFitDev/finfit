import 'dart:convert';

import 'package:excerbuys/utils/constants.dart';

class ContentWithLoading<T> {
  T content;
  bool isLoading = false;

  ContentWithLoading({
    required this.content,
  });

  ContentWithLoading<T> copyWith({T? content, bool? isLoading}) {
    final data = ContentWithLoading<T>(
      content: content ?? this.content,
    );
    data.isLoading = isLoading ?? this.isLoading;
    return data;
  }
}

class ContentWithTimestamp<T> {
  final T content;
  final DateTime timestamp;
  final int validFor; // in milliseconds

  ContentWithTimestamp({
    required this.content,
    this.validFor = ONE_HOUR_CACHE_VALIDITY_PERIOD,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ContentWithTimestamp.fromJson(
      String jsonData, T Function(Object jsonData) deserializer) {
    final Map<String, dynamic> map = jsonDecode(jsonData);
    return ContentWithTimestamp<T>(
      content: deserializer(map['data']),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  ContentWithTimestamp<T> copyWith({T? content, DateTime? timestamp}) {
    return ContentWithTimestamp<T>(
      content: content ?? this.content,
      validFor: validFor,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  bool isExpired() {
    return timestamp
        .add(Duration(milliseconds: validFor))
        .isBefore(DateTime.now());
  }

  String toJson(Object Function(T content) serializer) {
    final map = {
      'data': serializer(content),
      'timestamp': timestamp.toIso8601String(),
    };
    return jsonEncode(map);
  }
}
