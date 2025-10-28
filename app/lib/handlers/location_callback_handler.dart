import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/location_dto.dart';

@pragma('vm:entry-point')
class LocationCallbackHandler {
  static const String isolateName = "LocatorIsolate";

  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    // Called once when background locator starts
    print('Background locator initialized');
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    print('Background locator disposed');
  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    // This runs every time a new location is available
    print(
        'Location in background: ${locationDto.latitude}, ${locationDto.longitude}');

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send({
      'latitude': locationDto.latitude,
      'longitude': locationDto.longitude,
      'accuracy': locationDto.accuracy,
      'altitude': locationDto.altitude,
      'heading': locationDto.heading,
      'speed': locationDto.speed,
      'speedAccuracy': locationDto.speedAccuracy,
    });
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
    print('Notification clicked');
  }
}
