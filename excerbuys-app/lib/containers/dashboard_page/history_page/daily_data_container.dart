import 'package:excerbuys/components/dashboard_page/history_page/calendar.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/steps_activity_card.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/store/controllers/activity/steps_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DailyDataContainer extends StatefulWidget {
  const DailyDataContainer({super.key});

  @override
  State<DailyDataContainer> createState() => _DailyDataContainerState();
}

class _DailyDataContainerState extends State<DailyDataContainer> {
  final ScrollController _scrollController = ScrollController();
  double _lastOffsetForward = 0;
  double _lastOffsetBackwards = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(onScrollDirectionChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onScrollDirectionChange() {
    if (_scrollController.offset <= 56) {
      historyController.setCategoryHeaderVisible(true);
    }
    if (_scrollController.offset > 0) {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _lastOffsetForward = _scrollController.offset;
        if ((_scrollController.offset - _lastOffsetBackwards).abs() > 80) {
          historyController.setCategoryHeaderVisible(false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _lastOffsetBackwards = _scrollController.offset;
        if ((_scrollController.offset - _lastOffsetForward).abs() > 80) {
          historyController.setCategoryHeaderVisible(true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.only(top: HORIZOTAL_PADDING + 56),
      child: Column(
        children: [
          Calendar(),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<int>(
              stream: historyController.daysAgoCalendarStream,
              builder: (context, daysSnapshot) {
                return (daysSnapshot.data ?? 0) < 0
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          StreamBuilder<ContentWithLoading<IStoreStepsData>>(
                              stream: stepsController.userStepsStream,
                              builder: (context, stepsSnapshot) {
                                final IStoreStepsData stepsData =
                                    stepsSnapshot.hasData
                                        ? stepsSnapshot.data!.content
                                        : {};
                                return StepsActivityCard(
                                  isLoading:
                                      stepsSnapshot.data?.isLoading ?? false,
                                  stepsData: stepsData,
                                  daysAgo: daysSnapshot.data ?? 0,
                                );
                              }),
                          StreamBuilder<
                                  ContentWithLoading<
                                      Map<String, ITrainingEntry>>>(
                              stream: trainingsController.userTrainingsStream,
                              builder: (context, snapshot) {
                                final Map<String, ITrainingEntry> trainings =
                                    snapshot.hasData
                                        ? Map.fromEntries(snapshot
                                            .data!.content.entries
                                            .toList()
                                            .where((element) =>
                                                areDatesEqualRespectToDay(
                                                    element.value.createdAt,
                                                    DateTime.now().subtract(
                                                        Duration(
                                                            days: daysSnapshot
                                                                    .data ??
                                                                0)))))
                                        : {};
                                return RecentTrainingSection(
                                  isLoading: snapshot.data?.isLoading ?? false,
                                  recentTraining: trainings,
                                  isDaily: true,
                                );
                              }),
                        ],
                      );
              }),
        ],
      ),
    );
  }
}
