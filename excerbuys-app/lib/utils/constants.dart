import 'package:flutter/material.dart';
import 'package:health/health.dart';

const String APP_TITLE = 'Excerbuys';
const String BACKEND_BASE_URL = 'http://192.168.1.104:3000/';
GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();
RegExp EMAIL_REGEX = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
const String WEB_CLIENT_GOOGLE_ID =
    '675848705064-ope52veb5ql854hdlkm044sk37j6lkt8.apps.googleusercontent.com';

final List<HealthDataType> HEALTH_DATA_TYPES = [
  // HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.WORKOUT,
  HealthDataType.STEPS
];
final List<HealthDataAccess> HEALTH_DATA_PERMISSIONS =
    HEALTH_DATA_TYPES.map((e) => HealthDataAccess.READ).toList();

const double HORIZOTAL_PADDING = 16;

const ColorFilter greyscale = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);
