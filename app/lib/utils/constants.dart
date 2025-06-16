import 'package:flutter/material.dart';
import 'package:health/health.dart';

const String APP_TITLE = 'FinFit';
const String BACKEND_BASE_URL = 'http://192.168.1.14:3000/';
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
const double MODAL_BORDER_RADIUS = 20;

const String DEVICE_ID_KEY = 'device_id';
const String INSTALL_TIMESTAMP_KEY = 'install_timestamp';
const String ACCESS_TOKEN_KEY = 'access_token';
const String REFRESH_TOKEN_KEY = 'refresh_token';
const String CURRENT_USER_KEY = 'current_user';
const String RECENT_RECIPIENTS_KEY = 'recent_recipients';
const String CART_STATE_KEY = 'cart_state';
const String MAX_PRICE_RANGES_KEY = 'max_price_ranges';
const String AVAILABLE_SHOP_CATEGORIES_KEY = 'available_shop_categories';

// one hour
const int ONE_HOUR_CACHE_VALIDITY_PERIOD = 1000 * 60 * 60;

const String INPOST_OUT_OF_THE_BOX_DB_UUID =
    'c06db240-c410-4866-b960-0549ee48c106';
const String INPOST_COURIER_DB_UUID = 'd01cfc11-ba95-41c3-a75d-337add2c33e8';
const String COURIER_DB_UUID = '042fa60e-fff9-4876-a522-ea1c701676b8';
const String SHOP_DELIVERY_DB_UUID = 'd550429b-466c-43ee-b48c-d4023c2b3e4f';
