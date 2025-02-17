import 'package:flutter/material.dart';
import 'package:health/health.dart';

const String APP_TITLE = 'Excerbuys';
const String BACKEND_BASE_URL = 'http://192.168.254.120:3000/';
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
const double MAIN_HEADER_HEIGHT = 55;
const double APPBAR_HEIGHT = 80;

const String DEVICE_ID_KEY = 'device_id';
const String INSTALL_TIMESTAMP_KEY = 'install_timestamp';
const String ACCESS_TOKEN_KEY = 'access_token';
const String REFRESH_TOKEN_KEY = 'refresh_token';
const String CURRENT_USER_KEY = 'current_user';
