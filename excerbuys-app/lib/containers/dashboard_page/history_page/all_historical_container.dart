import 'package:excerbuys/components/shared/buttons/category_button.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class AllHistoricalContainer extends StatefulWidget {
  const AllHistoricalContainer({super.key});

  @override
  State<AllHistoricalContainer> createState() => _AllHistoricalContainerState();
}

class _AllHistoricalContainerState extends State<AllHistoricalContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24, top: 16),
      child: StreamBuilder<HISTORY_CATEGORY>(
          stream: historyController.historyCategoryStream,
          builder: (context, snapshot) {
            return Column(
              children: [
                // actual data
                StreamBuilder<ContentWithLoading<Map<String, ITrainingEntry>>>(
                    stream: trainingsController.userTrainingsStream,
                    builder: (context, snapshot) {
                      final Map<String, ITrainingEntry> trainings =
                          snapshot.hasData
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
          }),
    );
  }
}
