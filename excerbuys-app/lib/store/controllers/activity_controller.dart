import 'dart:io';

import 'package:excerbuys/utils/activity/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class ActivityController {
  // obtaining health data auth
  final BehaviorSubject<bool> _healthAuthorized = BehaviorSubject.seeded(false);
  Stream<bool> get healthAuthorizedStream => _healthAuthorized.stream;
  bool get healthAuthorized => _healthAuthorized.value;
  setHealthAuth(bool isAuth) {
    _healthAuthorized.add(isAuth);
  }

  Future<void> authorize() async {
    if (await Permission.activityRecognition.status.isDenied) {
      await Permission.activityRecognition.request();
    }
    if (await Permission.location.status.isDenied) {
      await Permission.location.request();
    }
    final List<HealthDataType> types = HEALTH_DATA_TYPES;

    final List<HealthDataAccess> permissions = HEALTH_DATA_PERMISSIONS;

    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    if (hasPermissions == null || !hasPermissions) {
      try {
        final bool authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
        setHealthAuth(authorized);
      } catch (error) {
        debugPrint("Couldn't authorize health: $error");
        setHealthAuth(false);
      }
    } else {
      setHealthAuth(true);
    }
  }

  final BehaviorSubject<HealthConnectSdkStatus> __healthSdkStatus =
      BehaviorSubject.seeded(HealthConnectSdkStatus.sdkUnavailable);
  Stream<HealthConnectSdkStatus> get healthSdkStatusStream =>
      __healthSdkStatus.stream;
  HealthConnectSdkStatus get healthSdkStatus => __healthSdkStatus.value;
  setHealthSdkStatus(HealthConnectSdkStatus status) {
    __healthSdkStatus.add(status);
  }

  Future<void> checkHealthConnectSdk() async {
    HealthConnectSdkStatus? status = await Health().getHealthConnectSdkStatus();
    if (status != HealthConnectSdkStatus.sdkAvailable) {
      await Health().installHealthConnect();
      status = await Health().getHealthConnectSdkStatus();
    }
    setHealthSdkStatus(status ?? HealthConnectSdkStatus.sdkUnavailable);
  }

  // values
  final BehaviorSubject<Map<String, HealthDataPoint>> _userActivity =
      BehaviorSubject.seeded({});

  Stream<Map<String, HealthDataPoint>> get userActivityStream =>
      _userActivity.stream.map(checkActivityData);

  Map<String, HealthDataPoint> get userActivity => _userActivity.value;

  addUserActivity(Map<String, HealthDataPoint> activity) {
    // Merging new activity into the existing one
    Map<String, HealthDataPoint> newActivity = {...userActivity, ...activity};

    // Emit the updated activity into the BehaviorSubject
    _userActivity.add(newActivity);
  }

  Future<void> fetchData() async {
    if (!healthAuthorized) {
      print('Health unauthorized');
      return;
    }

    if (Platform.isAndroid &&
        healthSdkStatus != HealthConnectSdkStatus.sdkAvailable) {
      print('Health connect unauthorized');
      return;
    }

    // final lastUpdated = userController.currentUser?.updatedAt;
    final now = DateTime.now();
    // final Duration difference = now.difference(lastUpdated!);

    final yesterday = now.subtract(Duration(hours: 24));

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: HEALTH_DATA_TYPES,
        startTime: yesterday,
        endTime: now,
      );
      print('$healthData health data');

      healthData = Health().removeDuplicates(healthData);
      Map<String, HealthDataPoint> values = {
        for (var el in healthData) el.uuid: el,
      };

      addUserActivity(values);
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }
  }
}

ActivityController activityController = ActivityController();
