import 'package:excerbuys/components/dashboard_page/history_page/calendar.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/steps_activity_card.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/transactions_section.dart';
import 'package:excerbuys/store/controllers/activity/steps_controller/steps_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DailyDataContainer extends StatefulWidget {
  const DailyDataContainer({super.key});

  @override
  State<DailyDataContainer> createState() => _DailyDataContainerState();
}

class _DailyDataContainerState extends State<DailyDataContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                                  getFilteredEntries(
                                      snapshot.data?.content,
                                      (element) => areDatesEqualRespectToDay(
                                          element.value.createdAt,
                                          DateTime.now().subtract(Duration(
                                              days: daysSnapshot.data ?? 0))));

                              return RecentTrainingSection(
                                isLoading: snapshot.data?.isLoading ?? false,
                                recentTraining: trainings,
                                isDaily: true,
                              );
                            }),
                        StreamBuilder<
                                ContentWithLoading<
                                    Map<String, ITransactionEntry>>>(
                            stream:
                                transactionsController.allTransactionsStream,
                            builder: (context, snapshot) {
                              final Map<String, ITransactionEntry>
                                  transactions = getFilteredEntries(
                                      snapshot.data?.content,
                                      (element) => areDatesEqualRespectToDay(
                                          element.value.createdAt,
                                          DateTime.now().subtract(Duration(
                                              days: daysSnapshot.data ?? 0))));

                              return TransactionsSection(
                                isLoading: snapshot.data?.isLoading ?? false,
                                recentTransactions: transactions,
                                isDaily: true,
                              );
                            }),
                      ],
                    );
            }),
      ],
    );
  }
}
