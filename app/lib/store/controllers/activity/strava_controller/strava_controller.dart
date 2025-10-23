import 'dart:io';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/activity/requests.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

part 'mutations.dart';
part 'effects.dart';
part 'selectors.dart';

class StravaController {
  final BehaviorSubject<bool> _healthAuthorized = BehaviorSubject.seeded(false);
  Stream<bool> get healthAuthorizedStream => _healthAuthorized.stream;
  bool get healthAuthorized => _healthAuthorized.value;

  final BehaviorSubject<HealthConnectSdkStatus> __healthSdkStatus =
      BehaviorSubject.seeded(HealthConnectSdkStatus.sdkUnavailable);
  Stream<HealthConnectSdkStatus> get healthSdkStatusStream =>
      __healthSdkStatus.stream;
  HealthConnectSdkStatus get healthSdkStatus => __healthSdkStatus.value;

  final BehaviorSubject<double> _todaysPoints = BehaviorSubject.seeded(0);
  Stream<double> get todaysPointsStream => _todaysPoints.stream;
  double get todaysPoints => _todaysPoints.value;

  final BehaviorSubject<double> _totalPointsToAdd = BehaviorSubject.seeded(0);
  Stream<double> get totalPointsToAddStream => _totalPointsToAdd.stream;
  double get totalPointsToAdd => _totalPointsToAdd.value;
}

StravaController stravaController = StravaController();
