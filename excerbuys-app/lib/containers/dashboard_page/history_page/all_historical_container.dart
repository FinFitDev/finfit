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

class AllHistoricalContainer extends StatefulWidget {
  const AllHistoricalContainer({super.key});

  @override
  State<AllHistoricalContainer> createState() => _AllHistoricalContainerState();
}

class _AllHistoricalContainerState extends State<AllHistoricalContainer>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;
  double _lastOffsetForward = 0;
  double _lastOffsetBackwards = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.repeat();
    _scrollController.addListener(onReachEnd);
    _scrollController.addListener(onScrollDirectionChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onReachEnd() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        trainingsController.canFetchMore &&
        !trainingsController.lazyLoadOffset.isLoading) {
      trainingsController.lazyLoadMoreTrainings();
    }
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
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 24, top: 56),
      child: StreamBuilder<HISTORY_CATEGORY>(
          stream: historyController.historyCategoryStream,
          builder: (context, snapshot) {
            return Column(
              children: [
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
                //   child: Row(
                //     children: [
                //       CategoryButton(
                //         title: 'Workouts',
                //         activeBackgroundColor: colors.primaryContainer,
                //         backgroundColor: Colors.transparent,
                //         activeTextColor: colors.tertiaryContainer,
                //         textColor: colors.tertiaryContainer,
                //         onPressed: () {
                //           historyController
                //               .setHistoryCategory(HISTORY_CATEGORY.WORKOUTS);
                //         },
                //         fontSize: 13,
                //         isActive: snapshot.data == HISTORY_CATEGORY.WORKOUTS,
                //       ),
                //       SizedBox(width: 10),
                //       CategoryButton(
                //         title: 'Transactions',
                //         activeBackgroundColor: colors.primaryContainer,
                //         backgroundColor: Colors.transparent,
                //         activeTextColor: colors.tertiaryContainer,
                //         textColor: colors.tertiaryContainer,
                //         onPressed: () {
                //           historyController.setHistoryCategory(
                //               HISTORY_CATEGORY.TRANSACTIONS);
                //         },
                //         fontSize: 13,
                //         isActive:
                //             snapshot.data == HISTORY_CATEGORY.TRANSACTIONS,
                //       ),
                //     ],
                //   ),
                // ),

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
          }),
    );
  }
}
