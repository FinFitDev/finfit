import 'dart:math';

import 'package:excerbuys/components/shared/indicators/ellipse/ellipse_painter.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/goals_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/news_container.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';

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
    return Stack(
      children: [
        StreamBuilder<double>(
            stream: dashboardController.scrollDistanceStream,
            builder: (context, snapshot) {
              return Opacity(
                opacity: (snapshot.data ?? 0) > 300 ? 0 : 1,
                child: Positioned(
                  child: BalanceContainer(
                    balance: 0,
                  ),
                ),
              );
            }),
        NotificationListener<ScrollNotification>(
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
              child: Container(
                margin: EdgeInsets.only(top: 250),
                padding: EdgeInsets.only(
                    top: 80.0 + layoutController.statusBarHeight,
                    bottom: 80 + layoutController.bottomPadding),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NewsContainer(),
                      AvailableOffers(
                          // isLoading: true,
                          ),
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
                                    // isLoading: snapshot.hasData
                                    //     ? snapshot.data!.isLoading
                                    //     : null,
                                  );
                                });
                          }),
                      // GoalsContainer(
                      //     // isLoading: true,
                      //     ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
