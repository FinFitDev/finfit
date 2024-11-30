import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';

class AppController {
  restoreStateFromStorage() async {
    await authController.restoreAuthStateFromStorage();
    await userController.restoreCurrentUserStateFromStorage();
  }
}

AppController appController = AppController();
