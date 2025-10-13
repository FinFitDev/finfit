import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/workout_info_modal.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class RecentTrainingSection extends StatefulWidget {
  final Map<String, ITrainingEntry> recentTraining;
  final bool? isLoading;
  final bool? isDaily;
  final bool? hideTitle;
  final bool? allowLoadMore;

  const RecentTrainingSection({
    super.key,
    required this.recentTraining,
    this.isLoading,
    this.isDaily,
    this.hideTitle,
    this.allowLoadMore,
  });

  @override
  State<RecentTrainingSection> createState() => _RecentTrainingSectionState();
}

class _RecentTrainingSectionState extends State<RecentTrainingSection> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    // Empty state
    if (widget.recentTraining.isEmpty && widget.isLoading != true) {
      return emptyActivity(
        colors,
        texts,
        widget.isDaily ?? false,
        widget.hideTitle ?? false,
      );
    }

    return Container(
      margin: EdgeInsets.only(
        left: HORIZOTAL_PADDING,
        right: HORIZOTAL_PADDING,
        top: widget.hideTitle == true ? 0 : 30,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.hideTitle != true)
            Text(
              widget.isDaily == true ? 'Daily workouts' : 'Last workouts',
              style: texts.headlineLarge,
            ),
          if (widget.isLoading == true)
            loadingWorkouts(widget.hideTitle ?? false)
          else
            ListView.builder(
              padding: EdgeInsets.only(top: widget.hideTitle == true ? 0 : 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.recentTraining.values.length,
              itemBuilder: (context, index) {
                final entry = widget.recentTraining.values.elementAt(index);
                final type = HealthWorkoutActivityType.values
                    .firstWhere((el) => el.name == entry.type);

                return Container(
                  margin: EdgeInsets.only(top: index != 0 ? 16 : 0),
                  child: ActivityCard(
                    activityType: parseActivityType(type),
                    points: entry.points,
                    date: parseDate(entry.createdAt),
                    duration: entry.duration,
                    // TODO: change to dstance

                    distance: entry.calories,
                    onPressed: () {
                      openModal(
                        context,
                        WorkoutInfoModal(workoutId: entry.uuid),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

Widget emptyActivity(
  ColorScheme colors,
  TextTheme texts,
  bool isDaily,
  bool hideTitle,
) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: HORIZOTAL_PADDING,
      vertical: hideTitle ? 0 : 24,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hideTitle)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              isDaily ? 'Daily workouts' : 'No workouts yet',
              style: texts.headlineLarge,
            ),
          ),
        Text(
          isDaily
              ? 'Could not find workout data for the selected date. Make sure to change that next time :)'
              : 'Start working out to earn finpoints and claim your discounts in the shop!',
          style: TextStyle(color: colors.primaryFixedDim),
        ),
      ],
    ),
  );
}

Widget loadingWorkouts(bool hideTitle) {
  return Container(
    margin: EdgeInsets.only(top: hideTitle ? 0 : 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        UniversalLoaderBox(height: 115),
        SizedBox(height: 16),
        UniversalLoaderBox(height: 115),
        SizedBox(height: 16),
        UniversalLoaderBox(height: 115),
        SizedBox(height: 16),
        UniversalLoaderBox(height: 115),
        SizedBox(height: 16),
        UniversalLoaderBox(height: 115),
      ],
    ),
  );
}
