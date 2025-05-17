import 'dart:async';
import 'dart:math';

import 'package:excerbuys/components/dashboard_page/history_page/buttons_switch.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/historical_transactions.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/historical_workouts.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/daily_data_container.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/animated_switcher_wrapper.dart';
import 'package:excerbuys/wrappers/infinite_list_wrapper.dart';
import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final ValueNotifier<double> scrollMoreProgress = ValueNotifier(0.0);
  final ValueNotifier<bool> isScrolling = ValueNotifier(false);

  Timer? animationProgressTimer;
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RECENT_DATA_CATEGORY>(
        stream: historyController.recentPageUpdateTrigger(),
        builder: (context, snapshot) {
          return InfiniteListWrapper(
              on: snapshot.data != RECENT_DATA_CATEGORY.DAILY,
              padding:
                  EdgeInsets.only(bottom: APPBAR_HEIGHT + HORIZOTAL_PADDING),
              canFetchMore: snapshot.data == RECENT_DATA_CATEGORY.WORKOUTS
                  ? trainingsController.canFetchMore
                  : transactionsController.canFetchMore,
              onLoadMore: snapshot.data == RECENT_DATA_CATEGORY.WORKOUTS
                  ? trainingsController.lazyLoadMoreTrainings
                  : transactionsController.lazyLoadMoreTransactions,
              isLoadingMoreData: snapshot.data == RECENT_DATA_CATEGORY.WORKOUTS
                  ? trainingsController.lazyLoadOffset.isLoading
                  : transactionsController.lazyLoadOffset.isLoading,
              onRefresh: snapshot.data == RECENT_DATA_CATEGORY.WORKOUTS
                  ? trainingsController.refresh
                  : transactionsController.refresh,
              isRefreshing: snapshot.data == RECENT_DATA_CATEGORY.WORKOUTS
                  ? trainingsController.userTrainings.isLoading
                  : transactionsController.allTransactions.isLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height:
                        layoutController.statusBarHeight + MAIN_HEADER_HEIGHT,
                  ),
                  // buttons switch between daily data and all historical data
                  ButtonsSwitch(onPressed: (item) {
                    historyController.setActiveCategory(item['category']);
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
                  }),

                  SizedBox(
                    height: 8,
                  ),

                  AnimatedSwitcherWrapper(
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
                          : snapshot.data == RECENT_DATA_CATEGORY.TRANSACTIONS
                              ? Container(
                                  constraints: BoxConstraints(
                                      minHeight: _isAnimating ? 15000 : 0),
                                  key: ValueKey('Transactions'),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable: scrollMoreProgress,
                                          builder: (context, value, child) {
                                            return HistoricalTransactions(
                                              scrollLoadMoreProgress:
                                                  min(max(value, 0), 100),
                                            );
                                          })
                                    ],
                                  ),
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                      minHeight: _isAnimating ? 15000 : 0),
                                  key: ValueKey('Workouts'),
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
                                ))
                ],
              ));
        });
  }
}
