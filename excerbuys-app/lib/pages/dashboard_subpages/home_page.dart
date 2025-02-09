import 'dart:math';

import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/steps_activity_card.dart';
import 'package:excerbuys/components/shared/indicators/ellipse/ellipse_painter.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/goals_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/news_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/progress_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_activity_container.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/steps_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
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
              return StreamBuilder<double?>(
                  stream: userController.userBalanceStream,
                  builder: (context, balance) {
                    return Positioned(
                      top: -(max(0.0, snapshot.data ?? 0)) / 4,
                      // we only animate for the newly added points
                      child: balance.hasData
                          ? BalanceContainer(
                              balance: (balance.data ?? 0).round(),
                            )
                          : SizedBox.shrink(),
                    );
                  });
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
                      NewsContainer(
                          // isLoading: true,
                          ),
                      AvailableOffers(
                          // isLoading: true,
                          ),
                      ProgressOffersContainer(),

                      StreamBuilder<ContentWithLoading<IStoreStepsData>>(
                          stream: stepsController.userStepsStream,
                          builder: (context, stepsSnapshot) {
                            final IStoreStepsData stepsData =
                                stepsSnapshot.hasData
                                    ? stepsSnapshot.data!.content
                                    : {};
                            return stepsData.isNotEmpty
                                ? StepsActivityCard(
                                    points: 1203,
                                    stepsData: stepsData,
                                  )
                                : SizedBox.shrink();
                          }),
                      StreamBuilder<
                              ContentWithLoading<Map<String, ITrainingEntry>>>(
                          stream: trainingsController.usetTrainingsStream,
                          builder: (context, snapshot) {
                            return RecentTrainingSection(
                                recentTraining: snapshot.hasData
                                    ? Map.fromEntries(snapshot
                                        .data!.content.entries
                                        .toList()
                                        .sublist(
                                            0,
                                            min(
                                                snapshot.data!.content.values
                                                    .length,
                                                4)))
                                    : {});
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
