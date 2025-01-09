import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card.dart';
import 'package:excerbuys/types/activity.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Recent training sessions',
            style: TextStyle(fontSize: 14, color: colors.tertiary),
            textAlign: TextAlign.left,
          ),
        ),
        ...recentTraining.values.toList().asMap().entries.map((entry) {
          ITrainingEntry healthData = entry.value;
          final type = HealthWorkoutActivityType.values
              .firstWhere((el) => el.name == healthData.type);

          return ActivityCard(
            activityType: parseActivityType(type),
            points: healthData.points,
            date: parseDate(healthData.createdAt),
          );
        })
      ],
    );
  }
}
