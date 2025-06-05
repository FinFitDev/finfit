part of 'history_controller.dart';

extension HistoryControllerSelectors on HistoryController {
  Stream<RECENT_DATA_CATEGORY> recentPageUpdateTrigger() {
    return Rx.combineLatest5(
      historyController.activeCategoryRecentDataStream,
      transactionsController.lazyLoadOffsetStream,
      trainingsController.lazyLoadOffsetStream,
      trainingsController.userTrainingsStream,
      transactionsController.allTransactionsStream,
      (RECENT_DATA_CATEGORY category,
          ContentWithLoading<int> transactionsOffset,
          ContentWithLoading<int> trainingsOffset,
          ContentWithLoading<Map<String, ITrainingEntry>> trainings,
          ContentWithLoading<Map<String, ITransactionEntry>> transactions) {
        return category;
      },
    );
  }
}
