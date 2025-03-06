import 'package:excerbuys/components/shared/buttons/category_button.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HistoricalWorkouts extends StatefulWidget {
  const HistoricalWorkouts({super.key});

  @override
  State<HistoricalWorkouts> createState() => _HistoricalWorkoutsState();
}

class _HistoricalWorkoutsState extends State<HistoricalWorkouts>
    with TickerProviderStateMixin {
  // final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;
  // double _lastOffsetForward = 0;
  // double _lastOffsetBackwards = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<HISTORY_CATEGORY>(
        stream: historyController.historyCategoryStream,
        builder: (context, snapshot) {
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
              StreamBuilder<ContentWithLoading<int>>(
                  stream: trainingsController.lazyLoadOffsetStream,
                  builder: (context, loadingSnapshot) {
                    return Container(
                      margin: EdgeInsets.all(
                          loadingSnapshot.data?.isLoading == true ? 30 : 0),
                      child: loadingSnapshot.data?.isLoading == true
                          ? SpinKitCircle(
                              color: colors.secondary,
                              size: 30.0,
                              controller: _animationController,
                            )
                          : SizedBox.shrink(),
                    );
                  })
            ],
          );
        });
  }
}
