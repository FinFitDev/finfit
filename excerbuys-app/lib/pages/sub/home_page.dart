import 'dart:math';

import 'package:excerbuys/containers/dashboard_page/home_page/available_offers.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_activity_container.dart';
import 'package:excerbuys/store/controllers/activity_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function() fetchActivity;
  const HomePage({super.key, required this.fetchActivity});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.fetchActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 80.0 + layoutController.statusBarHeight,
          bottom: 2000 + layoutController.bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BalanceContainer(
            balance: 0,
          ),
          StreamBuilder<Map<String, HealthDataPoint>>(
              stream: activityController.userActivityStream,
              builder: (context, snapshot) {
                return RecentActivityContainer(
                  recentActivity: snapshot.hasData
                      ? Map.fromEntries(snapshot.data!.entries
                          .toList()
                          .sublist(0, min(snapshot.data!.values.length, 4)))
                      : {},
                );
              }),
          AvailableOffers()
        ],
      ),
    );
  }
}
