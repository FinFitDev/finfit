import 'package:excerbuys/components/dashboard_page/main_header.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/pages/sub/home_page.dart';
import 'package:excerbuys/store/controllers/activity_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:excerbuys/components/animated_balance.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // int _balance = 132992;

  /// All the data types that are available on Android and iOS.
  // List<HealthDataType> get types => (Platform.isAndroid)
  //     ? dataTypeKeysAndroid
  //     : (Platform.isIOS)
  //         ? dataTypeKeysIOS
  //         : [];

  // List<HealthDataAccess> get permissions => GeneralConstants.HEALTH_DATA_TYPES
  //     .map((e) => HealthDataAccess.READ)
  //     .toList();

  Future<void> fetchActivity() async {
    Health().configure();
    await activityController.authorize();
    await activityController.checkHealthSdk();
    await activityController.fetchData();
  }

  // Future<void> logOut() async {
  //   final bool res = await authController.logOut();

  //   if (res) {
  //     GeneralUtils.navigateWithClear(route: '/login');
  //   }
  // }

  // Future<void> updatePoints() async {
  //   if (userController.currentUser == null) {
  //     return;
  //   }
  //   final bool _ = await userController.updatePointsScore(
  //       authController.accessToken,
  //       userController.currentUser!.id.toString(),
  //       _stepsTotal.round(),
  //       DateTime.now());
  // }

  // Widget get _contentFetchingData => Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Container(
  //             padding: const EdgeInsets.all(20),
  //             child: const CircularProgressIndicator(
  //               strokeWidth: 10,
  //             )),
  //         const Text('Fetching data...')
  //       ],
  //     );

  // Widget get _contentDataReady => ListView.builder(
  //     itemCount: _healthDataList.length,
  //     itemBuilder: (_, index) {
  //       HealthDataPoint p = _healthDataList[index];
  //       if (p.value is AudiogramHealthValue) {
  //         return ListTile(
  //           title: Text("${p.typeString}: ${p.value}"),
  //           trailing: Text(p.unitString),
  //           subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
  //         );
  //       }
  //       if (p.value is WorkoutHealthValue) {
  //         return ListTile(
  //           title: Text(
  //               "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
  //           trailing:
  //               Text((p.value as WorkoutHealthValue).workoutActivityType.name),
  //           subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
  //         );
  //       }
  //       if (p.value is NutritionHealthValue) {
  //         return ListTile(
  //           title: Text(
  //               "${p.typeString} ${(p.value as NutritionHealthValue).mealType}: ${(p.value as NutritionHealthValue).name}"),
  //           trailing:
  //               Text('${(p.value as NutritionHealthValue).calories} kcal'),
  //           subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
  //         );
  //       }
  //       return ListTile(
  //         title: Text("${p.typeString}: ${p.value}"),
  //         trailing: Text(p.unitString),
  //         subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
  //       );
  //     });

  // final Widget _contentNoData = const Text('No Data to show');

  // final Widget _contentNotFetched =
  //     const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  //   Text("Press 'Auth' to get permissions to access health data."),
  //   Text("Press 'Fetch Data' to get health data."),
  //   Text("Press 'Add Data' to add some random health data."),
  //   Text("Press 'Delete Data' to remove some random health data."),
  // ]);

  // final Widget _authorized = const Text('Authorization granted!');

  // final Widget _authorizationNotGranted = const Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: [
  //     Text('Authorization not given.'),
  //     Text('You need to give all health permissions on Health Connect'),
  //   ],
  // );

  // Widget get _content => switch (_state) {
  //       AppState.DATA_READY => _contentDataReady,
  //       AppState.DATA_NOT_FETCHED => _contentNotFetched,
  //       AppState.FETCHING_DATA => _contentFetchingData,
  //       AppState.NO_DATA => _contentNoData,
  //       AppState.AUTHORIZED => _authorized,
  //       AppState.AUTH_NOT_GRANTED => _authorizationNotGranted,
  //     };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomePage(fetchActivity: fetchActivity),
          Positioned(child: MainHeader()),
        ],
      ),
      // appBar: AppBar(
      //   title: const Text('Health Example'),
      // ),
      // body: Column(
      //   children: [
      //     AnimatedBalance(balance: _balance),
      //     Wrap(
      //       spacing: 10,
      //       children: [
      //         TextButton(
      //             onPressed: () async {
      //               await userController.fetchCurrentUser('2');
      //               // setState(() {
      //               //   if (userController.currentUser != null) {
      //               //     _stepsTotal = userController.currentUser!.points;
      //               //   }
      //               // });
      //             },
      //             style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      //             child: const Text("Login",
      //                 style: TextStyle(color: Colors.white))),
      //         TextButton(
      //             onPressed: updatePoints,
      //             style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      //             child: const Text("Authenticate",
      //                 style: TextStyle(color: Colors.white))),
      //         TextButton(
      //             onPressed: fetchData,
      //             style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      //             child: const Text("Fetch Data",
      //                 style: TextStyle(color: Colors.white))),
      //         TextButton(
      //             onPressed: logOut,
      //             style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      //             child: const Text("Log out",
      //                 style: TextStyle(color: Colors.white))),
      //         TextButton(
      //             onPressed: () {
      //               setState(() {
      //                 Random random = Random();
      //                 _balance = _balance + random.nextInt(1000) - 500;
      //               });
      //             },
      //             style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      //             child: const Text("random balance",
      //                 style: TextStyle(color: Colors.white))),
      //         if (Platform.isAndroid &&
      //             _healthConnectStatus != HealthConnectSdkStatus.sdkAvailable)
      //           TextButton(
      //               onPressed: installHealthConnect,
      //               style: const ButtonStyle(
      //                   backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      //               child: const Text("Install Health Connect",
      //                   style: TextStyle(color: Colors.white))),
      //       ],
      //     ),
      //     const Divider(thickness: 3),
      //     Expanded(child: Center(child: _content))
      //   ],
      // ),
    );
  }
}
