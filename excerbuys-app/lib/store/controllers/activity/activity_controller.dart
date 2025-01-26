import 'dart:io';
import 'package:excerbuys/store/controllers/activity/steps_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/constants.dart';
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

// authorizing all neccessary libs
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

  // Stream<Map<int, int>> get userStepsStream =>
  //     _userActivity.stream.map();

  Future<void> fetchActivity() async {
    if (!healthAuthorized) {
      print('Health unauthorized');
      return;
    }

    if (Platform.isAndroid &&
        healthSdkStatus != HealthConnectSdkStatus.sdkAvailable) {
      print('Health connect unauthorized');
      return;
    }

    await trainingsController.fetchTrainings();
    await stepsController.fetchsSteps();
  }
}

ActivityController activityController = ActivityController();
