import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card.dart';
import 'package:excerbuys/components/loaders/universal_loader_box.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class RecentTrainingSection extends StatefulWidget {
  final Map<String, ITrainingEntry> recentTraining;
  final bool? isLoading;

  const RecentTrainingSection(
      {super.key, required this.recentTraining, this.isLoading});

  @override
  State<RecentTrainingSection> createState() => _RecentTrainingSectionState();
}

class _RecentTrainingSectionState extends State<RecentTrainingSection> {
  Map<String, List<ITrainingEntry>> _groupedTrainingsData = {};

  void groupData() {
    if (widget.recentTraining.isEmpty) {
      return;
    }

    final Map<String, List<ITrainingEntry>> groupedData = {};
    for (var el in widget.recentTraining.values) {
      final List<String> splitParsedDate = parseDate(el.createdAt).split(' ');
      final String dateKey = splitParsedDate.length == 3
          ? '${splitParsedDate[0]} ${splitParsedDate[1]}'
          : splitParsedDate[0];

      groupedData.putIfAbsent(dateKey, () => []).add(el);
    }

    setState(() {
      _groupedTrainingsData = groupedData;
    });
  }

  @override
  void initState() {
    groupData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RecentTrainingSection oldWidget) {
    if (oldWidget.recentTraining != widget.recentTraining) {
      groupData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Builder(builder: (BuildContext context) {
      if (widget.recentTraining.isEmpty) {
        return emptyActivity;
      }

      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING, vertical: 24),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            'Last workouts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colors.tertiary,
            ),
          ),
          Builder(builder: (context) {
            if (widget.isLoading == true) {
              return loadingWorkouts();
            }
            return Column(
              children: [
                ..._groupedTrainingsData.entries.indexed.map((el) {
                  final index = el.$1;
                  final key = el.$2.key;
                  final values = el.$2.value;

                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              key,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: colors.tertiaryContainer),
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 8),
                              height: 1,
                              color: colors.tertiaryContainer.withAlpha(100),
                            ))
                          ],
                        ),
                      ),
                      ...values.toList().asMap().entries.map((entry) {
                        ITrainingEntry healthData = entry.value;
                        final type = HealthWorkoutActivityType.values
                            .firstWhere((el) => el.name == healthData.type);

                        return ActivityCard(
                          index: 0,
                          activityType: parseActivityType(type),
                          points: healthData.points,
                          date: parseDate(healthData.createdAt),
                          duration: healthData.duration,
                          calories: healthData.calories,
                        );
                      })
                    ],
                  );
                }),
              ],
            );
          }),
        ]),
      );
    });
  }
}

final Widget emptyActivity = Builder(builder: (BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING, vertical: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            'No workouts yet',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: colors.tertiary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          textAlign: TextAlign.start,
          'Start working out to earn fitness points and claim your discounts in the shop!',
          style: TextStyle(
            color: colors.primaryFixedDim,
          ),
        ),
      ],
    ),
  );
});

Widget loadingWorkouts() {
  return Container(
      margin: EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UniversalLoaderBox(
            height: 20,
            width: 200,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70),
          SizedBox(
            height: 16,
          ),
          UniversalLoaderBox(
            height: 20,
            width: 150,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70),
          SizedBox(
            height: 16,
          ),
          UniversalLoaderBox(
            height: 20,
            width: 250,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70)
        ],
      ));
}
