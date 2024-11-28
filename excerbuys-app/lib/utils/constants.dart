import 'package:flutter/material.dart';

class GeneralConstants {
  static const String APP_TITLE = 'Excerbuys';
  static const String BACKEND_BASE_URL = 'http://192.168.254.103:5000/';
  static GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();
  static RegExp EMAIL_REGEX =
      RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
  static const String WEB_CLIENT_GOOGLE_ID =
      '675848705064-ope52veb5ql854hdlkm044sk37j6lkt8.apps.googleusercontent.com';
}
