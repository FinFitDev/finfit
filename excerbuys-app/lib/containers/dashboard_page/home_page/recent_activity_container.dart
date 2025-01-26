import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/recent_training_section.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/steps_activity_card.dart';
import 'package:excerbuys/components/loaders/universal_loader_box.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class RecentActivityContainer extends StatefulWidget {
  final Map<String, ITrainingEntry> recentTraining;
  final Map<int, int> todaysSteps;
  final bool? isLoading;

  const RecentActivityContainer(
      {super.key,
      required this.recentTraining,
      this.isLoading,
      required this.todaysSteps});

  @override
  State<RecentActivityContainer> createState() =>
      _RecentActivityContainerState();
}

class _RecentActivityContainerState extends State<RecentActivityContainer> {
  final Widget loadingContainer =
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(
      padding: const EdgeInsets.only(top: 0),
      child: UniversalLoaderBox(height: 25, width: 100),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 10),
      child: UniversalLoaderBox(
          height: 200, width: layoutController.relativeContentWidth),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 20),
      child: UniversalLoaderBox(height: 25, width: 100),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 10),
      child: UniversalLoaderBox(
          height: 50, width: layoutController.relativeContentWidth),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 5),
      child: UniversalLoaderBox(
          height: 50, width: layoutController.relativeContentWidth),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 5),
      child: UniversalLoaderBox(
          height: 50, width: layoutController.relativeContentWidth),
    ),
  ]);

  final Widget emptyActivity = Builder(builder: (BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'No activity yet',
              style: TextStyle(color: colors.tertiary, fontSize: 16),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            'Start working out to earn fitness points and claim your discounts in the shop!',
            style: TextStyle(
              color: colors.tertiaryContainer,
            ),
          ),
        ],
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: HORIZOTAL_PADDING,
          right: HORIZOTAL_PADDING,
          top: 30,
          bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Builder(builder: (BuildContext context) {
            if (widget.isLoading == true) {
              return loadingContainer;
            }

            if (widget.recentTraining.isEmpty && widget.todaysSteps.isEmpty) {
              return emptyActivity;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.todaysSteps.isNotEmpty
                    ? StepsActivityCard(
                        points: 1203,
                        stepsData: widget.todaysSteps,
                      )
                    : SizedBox.shrink(),
                widget.recentTraining.isNotEmpty
                    ? RecentTrainingSection(
                        recentTraining: widget.recentTraining)
                    : SizedBox.shrink()
              ],
            );
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                'Purchase history',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 8,
              ),
              ActivityCard(
                  activityType: ACTIVITY_TYPE.BIKE_RIDING,
                  date: 'Today 11:10',
                  points: -254,
                  isPurchase: true),
              ActivityCard(
                activityType: ACTIVITY_TYPE.BIKE_RIDING,
                date: 'Today 11:10',
                points: -254,
                isPurchase: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
