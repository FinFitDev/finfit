import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:rxdart/rxdart.dart';

class AppController {
  restoreStateFromStorage() async {
    await authController.restoreAuthStateFromStorage();
    await userController.restoreCurrentUserStateFromStorage();
  }

  final BehaviorSubject<String> _deviceId =
      BehaviorSubject.seeded('unknown_device');
  Stream<String> get deviceIdStream => _deviceId.stream;
  String get deviceId => _deviceId.value;
  setDeviceId(String id) {
    _deviceId.add(id);
  }

  Future<void> getDeviceId() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId ?? 'unkown';
    } on PlatformException {
      deviceId = 'unknown';
    }

    setDeviceId(deviceId);
  }
}

AppController appController = AppController();
