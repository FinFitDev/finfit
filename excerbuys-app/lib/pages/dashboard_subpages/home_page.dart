import 'dart:math';

import 'package:excerbuys/components/shared/indicators/ellipse/ellipse_painter.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/goals_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_activity_container.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/steps_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
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
    return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // ensure the notification only listens to vertical scroll
          if (scrollNotification.metrics.axis == Axis.vertical) {
            dashboardController
                .setScrollDistance(scrollNotification.metrics.pixels);
            return true;
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 80.0 + layoutController.statusBarHeight,
                bottom: 80 + layoutController.bottomPadding),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 250),
                  color: Theme.of(context).colorScheme.secondary.withAlpha(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<
                              ContentWithLoading<Map<String, ITrainingEntry>>>(
                          stream: trainingsController.usetTrainingsStream,
                          builder: (context, snapshot) {
                            return StreamBuilder<
                                    ContentWithLoading<Map<int, int>>>(
                                stream: stepsController.userStepsStream,
                                builder: (context, stepsSnapshot) {
                                  return RecentActivityContainer(
                                    recentTraining: snapshot.hasData
                                        ? Map.fromEntries(snapshot
                                            .data!.content.entries
                                            .toList()
                                            .sublist(
                                                0,
                                                min(
                                                    snapshot.data!.content
                                                        .values.length,
                                                    4)))
                                        : {},
                                    todaysSteps: stepsSnapshot.hasData
                                        ? stepsSnapshot.data!.content
                                        : {},
                                    isLoading: snapshot.hasData
                                        ? snapshot.data!.isLoading
                                        : null,
                                  );
                                });
                          }),
                      AvailableOffers(
                          // isLoading: true,
                          ),
                      GoalsContainer(
                          // isLoading: true,
                          )
                    ],
                  ),
                ),
                Positioned(
                  child: BalanceContainer(
                    balance: 0,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
