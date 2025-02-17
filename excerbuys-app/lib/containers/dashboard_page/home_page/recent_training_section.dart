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
  final bool? isDaily;
  final bool? hideTitle;
  final bool? allowLoadMore;

  const RecentTrainingSection(
      {super.key,
      required this.recentTraining,
      this.isLoading,
      this.isDaily,
      this.hideTitle,
      this.allowLoadMore});

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

      groupedData
          .putIfAbsent(
              '${dateKey}_${DateTime.now().difference(el.createdAt).inDays}',
              () => [])
          .add(el);
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
    final texts = Theme.of(context).textTheme;

    return Builder(builder: (BuildContext context) {
      if (widget.recentTraining.isEmpty) {
        return emptyActivity(colors, texts, widget.isDaily ?? false);
      }

      return Container(
        margin: EdgeInsets.symmetric(
            horizontal: HORIZOTAL_PADDING,
            vertical: widget.hideTitle == true ? 0 : 24),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          widget.hideTitle == true
              ? SizedBox.shrink()
              : Text(
                  widget.isDaily == true ? 'Daily workouts' : 'Last workouts',
                  style: texts.headlineLarge,
                ),
          Builder(builder: (context) {
            if (widget.isLoading == true) {
              return loadingWorkouts();
            }
            return ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _groupedTrainingsData.length,
              itemBuilder: (context, index) {
                final entry = _groupedTrainingsData.entries.elementAt(index);
                final keyParts = entry.key.split('_');
                final dateLabel = keyParts[0];
                final daysAgo = keyParts.length > 1 ? keyParts[1] : '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.isDaily != true)
                      Container(
                        margin: EdgeInsets.only(top: 12, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dateLabel,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: colors.tertiaryContainer),
                            ),
                            SizedBox(width: 6),
                            if (dateLabel != 'Today' &&
                                dateLabel != 'Yesterday')
                              Text(
                                '($daysAgo days ago)',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: colors.tertiaryContainer
                                        .withAlpha(150)),
                              ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 0,
                                color: colors.tertiaryContainer.withAlpha(100),
                              ),
                            )
                          ],
                        ),
                      ),
                    Column(
                      // Replaced inner ListView with Column
                      children: entry.value.map((healthData) {
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
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          }),
        ]),
      );
    });
  }
}

Widget emptyActivity(ColorScheme colors, TextTheme texts, bool isDaily) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING, vertical: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            isDaily == true ? 'Daily workouts' : 'No workouts yet',
            textAlign: TextAlign.start,
            style: texts.headlineLarge,
          ),
        ),
        Text(
          textAlign: TextAlign.start,
          isDaily == true
              ? 'Could not find workout data for the selected date. Make sure to change that next time :)'
              : 'Start working out to earn finpoints and claim your discounts in the shop!',
          style: TextStyle(
            color: colors.primaryFixedDim,
          ),
        ),
      ],
    ),
  );
}

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
