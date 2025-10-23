import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:flutter/material.dart';

class HistoricalWorkouts extends StatefulWidget {
  final double? scrollLoadMoreProgress;
  const HistoricalWorkouts({super.key, this.scrollLoadMoreProgress});

  @override
  State<HistoricalWorkouts> createState() => _HistoricalWorkoutsState();
}

class _HistoricalWorkoutsState extends State<HistoricalWorkouts> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<HISTORY_CATEGORY>(
        stream: historyController.historyCategoryStream,
        builder: (context, _) {
          return Column(
            children: [
              StreamBuilder<ContentWithLoading<Map<int, ITrainingEntry>>>(
                  stream: trainingsController.userTrainingsStream,
                  builder: (context, snapshot) {
                    final Map<int, ITrainingEntry> trainings = snapshot.hasData
                        ? Map.fromEntries(
                            snapshot.data!.content.entries.toList())
                        : {};
                    return RecentTrainingSection(
                      isLoading: snapshot.data?.isLoading ?? false,
                      recentTraining: trainings,
                      hideTitle: true,
                    );
                  }),
            ],
          );
        });
  }
}
