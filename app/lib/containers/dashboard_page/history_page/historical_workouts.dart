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
              // StreamBuilder<ContentWithLoading<int>>(
              //     stream: trainingsController.lazyLoadOffsetStream,
              //     builder: (context, loadingSnapshot) {
              //       return Container(
              //         margin: EdgeInsets.only(
              //             top: loadingSnapshot.data?.isLoading == true ? 20 : 0,
              //             bottom:
              //                 loadingSnapshot.data?.isLoading == true ? 40 : 0),
              //         child: loadingSnapshot.data?.isLoading == true
              //             ? SpinKitCircle(
              //                 color: colors.secondary,
              //                 size: 30.0,
              //                 controller: _animationController,
              //               )
              //             : trainingsController.canFetchMore
              //                 ? LoadMoreIndicator(
              //                     scrollLoadMoreProgress:
              //                         widget.scrollLoadMoreProgress,
              //                   )
              //                 : SizedBox.shrink(),
              //       );
              //     }),
            ],
          );
        });
  }
}
