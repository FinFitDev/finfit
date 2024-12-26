import 'package:excerbuys/components/dashboard_page/home_page/activity_card.dart';
import 'package:excerbuys/utils/activity/utils.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health/health.dart';

class RecentActivityContainer extends StatefulWidget {
  final Map<String, HealthDataPoint> recentActivity;
  const RecentActivityContainer({super.key, required this.recentActivity});

  @override
  State<RecentActivityContainer> createState() =>
      _RecentActivityContainerState();
}

class _RecentActivityContainerState extends State<RecentActivityContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                height: 1,
                color: colors.tertiaryContainer,
                margin: EdgeInsets.only(right: 16),
              )),
              RippleWrapper(
                  onPressed: () {},
                  child: SvgPicture.asset('assets/svg/launch.svg'))
            ],
          ),
          widget.recentActivity.isEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'No activity yet',
                          style:
                              TextStyle(color: colors.tertiary, fontSize: 16),
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
                )
              : Column(
                  children: [
                    ...widget.recentActivity.values
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      HealthDataPoint healthData = entry.value;

                      return ActivityCard(
                        isFirst: index == 0,
                        activityType: parseActivityType(
                            healthData.value is WorkoutHealthValue
                                ? (healthData.value as WorkoutHealthValue)
                                    .workoutActivityType
                                : null),
                        points: healthData.value is NumericHealthValue
                            ? (healthData.value as NumericHealthValue)
                                .numericValue
                                .round()
                            : (healthData.value as WorkoutHealthValue)
                                .totalEnergyBurned!
                                .round(),
                        date: parseDate(healthData.dateTo),
                      );
                    })
                  ],
                )
        ],
      ),
    );
  }
}
