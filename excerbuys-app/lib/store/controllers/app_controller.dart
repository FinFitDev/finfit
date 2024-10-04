import 'dart:convert';

import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

class AppController {
  restoreStateFromStorage() async {
    await authController.restoreAuthStateFromStorage();
    await userController.restoreCurrentUserStateFromStorage();
  }
}

AppController appController = AppController();
