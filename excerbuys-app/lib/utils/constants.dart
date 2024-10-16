import 'package:flutter/material.dart';

class GeneralConstants {
  static const String APP_TITLE = 'Excerbuys';
  static const String BACKEND_BASE_URL = 'http://192.168.254.103:5000/';
  static GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();
  static RegExp EMAIL_REGEX =
      RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
}
