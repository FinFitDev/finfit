import 'dart:async';
import 'dart:math';

import 'package:excerbuys/components/dashboard_page/history_page/buttons_switch.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/historical_transactions.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/historical_workouts.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/animated_switcher_wrapper.dart';
import 'package:excerbuys/wrappers/infinite_list_wrapper_v2.dart';
import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final ValueNotifier<double> scrollMoreProgress = ValueNotifier(0.0);
  final ValueNotifier<bool> isScrolling = ValueNotifier(false);
  ScrollController scrollController = ScrollController();

  Timer? animationProgressTimer;
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<RECENT_DATA_CATEGORY>(
        stream: historyController.recentPageUpdateTrigger(),
        builder: (context, snapshot) {
          return InfiniteListWrapperV2(
              scrollController: scrollController,
              on: true,
              padding: EdgeInsets.only(
                  bottom: APPBAR_HEIGHT + layoutController.bottomPadding),
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
              children: [
                Container(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Moves & Points',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Track your workouts, and every point you gain.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: colors.primaryFixedDim),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
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
                    child: snapshot.data == RECENT_DATA_CATEGORY.TRANSACTIONS
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
              ]);
        });
  }
}
