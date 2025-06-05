part of 'history_controller.dart';

extension HistoryControllerMutations on HistoryController {
  setActiveCategory(RECENT_DATA_CATEGORY category) {
    _activeCategoryRecentData.add(category);
  }

  setDaysAgoCalendar(int daysAgo) {
    _daysAgoCalendar.add(daysAgo);
  }

  setHistoryCategory(HISTORY_CATEGORY category) {
    _historyCategory.add(category);
  }
}
