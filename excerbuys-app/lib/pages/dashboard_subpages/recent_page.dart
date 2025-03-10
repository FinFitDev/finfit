import 'dart:async';
import 'dart:math';

import 'package:excerbuys/components/shared/buttons/category_button.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/historical_workouts.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/daily_data_container.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final ValueNotifier<double> scrollMoreProgress = ValueNotifier(0.0);
  final ValueNotifier<bool> isScrolling = ValueNotifier(false);

  final ScrollController _scrollController = ScrollController();
  Timer? animationProgressTimer;
  bool _isAnimating = false;
  final List<Map<String, dynamic>> categoryButtons = [
    {
      'title': 'Daily data',
      'icon': 'assets/svg/calendar.svg',
      'category': RECENT_DATA_CATEGORY.DAILY,
    },
    {
      'title': 'Transactions',
      'icon': 'assets/svg/wallet.svg',
      'category': RECENT_DATA_CATEGORY.TRANSACTIONS,
    },
    {
      'title': 'Workouts',
      'icon': 'assets/svg/dumbell.svg',
      'category': RECENT_DATA_CATEGORY.WORKOUTS,
    },
  ];

  void setLoadMoreWorkoutsProgressIndicator() {
    if (!trainingsController.canFetchMore ||
        trainingsController.lazyLoadOffset.isLoading) {
      return;
    }

    scrollMoreProgress.value = (_scrollController.position.pixels -
        _scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();

    historyController.activeCategoryRecentDataStream.listen((data) {
      if (data == RECENT_DATA_CATEGORY.TRANSACTIONS) {
        if (_scrollController.position.maxScrollExtent == 0 &&
            trainingsController.canFetchMore) {
          trainingsController.lazyLoadMoreTrainings();
        }
        _scrollController.removeListener(setLoadMoreWorkoutsProgressIndicator);
        _scrollController.addListener(setLoadMoreWorkoutsProgressIndicator);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Listener(
      onPointerUp: (event) {
        isScrolling.value = false;
        // if the progress indicator for load more data is full and we relase the scrollview
        if (scrollMoreProgress.value > 100 &&
            trainingsController.canFetchMore) {
          triggerVibrate(FeedbackType.light);
          trainingsController.lazyLoadMoreTrainings();
        }
      },
      onPointerDown: (event) {
        isScrolling.value = true;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.only(
            top: layoutController.statusBarHeight + MAIN_HEADER_HEIGHT,
            bottom: APPBAR_HEIGHT + HORIZOTAL_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // buttons switch between daily data and all historical data
            StreamBuilder<RECENT_DATA_CATEGORY>(
                stream: historyController.activeCategoryRecentDataStream,
                builder: (context, snapshot) {
                  return Container(
                    height: 76,
                    width: layoutController.relativeContentWidth,
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryButtons.length,
                      itemBuilder: (context, index) {
                        final item = categoryButtons[index];
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 10.0),
                          child: CategoryButton(
                            title: item['title'],
                            icon: item['icon'],
                            activeBackgroundColor: colors.secondary,
                            backgroundColor: colors.primaryContainer,
                            activeTextColor: colors.primary,
                            textColor: colors.tertiaryContainer,
                            onPressed: () {
                              historyController
                                  .setActiveCategory(item['category']);
                              animationProgressTimer?.cancel();
                              setState(() {
                                _isAnimating = true;
                              });
                              animationProgressTimer =
                                  Timer(Duration(milliseconds: 250), () {
                                setState(() {
                                  _isAnimating = false;
                                });
                              });
                            },
                            fontSize: 13,
                            isActive: snapshot.data == item['category'],
                          ),
                        );
                      },
                    ),
                  );
                }),
            SizedBox(
              height: 8,
            ),

            StreamBuilder<RECENT_DATA_CATEGORY>(
                stream: historyController.activeCategoryRecentDataStream,
                builder: (context, snapshot) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    switchInCurve: Curves.decelerate,
                    switchOutCurve: Curves.decelerate,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final fadeAnimation = Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(animation);

                      final scaleAnimation = Tween<double>(
                        begin: 0.995,
                        end: 1.0,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: snapshot.data == RECENT_DATA_CATEGORY.DAILY
                        ? Container(
                            constraints: BoxConstraints(
                                minHeight: _isAnimating ? 15000 : 0),
                            key: ValueKey('DailyData'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                DailyDataContainer(),
                              ],
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                                minHeight: _isAnimating ? 15000 : 0),
                            key: ValueKey('Workouts '),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: scrollMoreProgress,
                                    builder: (context, value, child) {
                                      return HistoricalWorkouts(
                                        scrollLoadMoreProgress:
                                            min(max(value, 0), 100),
                                      );
                                    })
                              ],
                            ),
                          ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
