import 'package:excerbuys/store/controllers/app_controller/app_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void loadApp() async {
    await appController.getDeviceId();
    await appController.getInstallTimestamp();
    await appController.restoreStateFromStorage();
    final String refreshToken = authController.refreshToken;
    final User? currentUser = userController.currentUser;

    if (refreshToken.isNotEmpty && currentUser != null) {
      navigateWithClear(route: '/dashboard');
    } else {
      navigateWithClear(route: '/welcome');
    }
  }

  @override
  void initState() {
    super.initState();

    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    layoutController.setStatusBarHeight(MediaQuery.of(context).padding.top);

    return Scaffold(
      body: Container(
        height: 300,
        color: Colors.blue,
      ),
    );
  }
}
