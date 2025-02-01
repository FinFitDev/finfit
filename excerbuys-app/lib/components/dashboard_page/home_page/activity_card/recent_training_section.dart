import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class RecentTrainingSection extends StatelessWidget {
  final Map<String, ITrainingEntry> recentTraining;

  const RecentTrainingSection({super.key, required this.recentTraining});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              'Recent training sessions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.tertiary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Text(
                  parseDate(DateTime.now()).split(' ')[0],
                  style: TextStyle(fontSize: 15, color: colors.primaryFixed),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: 8),
                  height: 1,
                  color: colors.primaryFixed.withAlpha(100),
                ))
              ],
            ),
          ),
          ActivityCard(
            index: 0,
            activityType: parseActivityType(HealthWorkoutActivityType.RUNNING),
            points: 123,
            date: parseDate(DateTime.now()),
          ),
          ActivityCard(
            index: 1,
            activityType: parseActivityType(HealthWorkoutActivityType.RUNNING),
            points: 123,
            date: parseDate(DateTime.now()),
          ),
          ActivityCard(
            index: 2,
            activityType: parseActivityType(HealthWorkoutActivityType.RUNNING),
            points: 123,
            date: parseDate(DateTime.now()),
          ),
          ActivityCard(
            index: 3,
            activityType: parseActivityType(HealthWorkoutActivityType.RUNNING),
            points: 123,
            date: parseDate(DateTime.now()),
          ),
          ActivityCard(
            index: 4,
            activityType: parseActivityType(HealthWorkoutActivityType.RUNNING),
            points: 123,
            date: parseDate(DateTime.now()),
          ),
          ...recentTraining.values.toList().asMap().entries.map((entry) {
            ITrainingEntry healthData = entry.value;
            final type = HealthWorkoutActivityType.values
                .firstWhere((el) => el.name == healthData.type);

            return ActivityCard(
              index: 1,
              activityType: parseActivityType(type),
              points: healthData.points,
              date: parseDate(healthData.createdAt),
            );
          })
        ],
      ),
    );
  }
}
