import 'package:excerbuys/types/enums.dart';
import 'package:rxdart/rxdart.dart';

class HisotryController {
  final BehaviorSubject<RECENT_DATA_CATEGORY> _activeCategoryRecentData =
      BehaviorSubject.seeded(RECENT_DATA_CATEGORY.DAILY);
  Stream<RECENT_DATA_CATEGORY> get activeCategoryRecentDataStream =>
      _activeCategoryRecentData.stream;
  RECENT_DATA_CATEGORY get activeCategoryRecentData =>
      _activeCategoryRecentData.value;
  setActiveCategory(RECENT_DATA_CATEGORY category) {
    _activeCategoryRecentData.add(category);
  }

  final BehaviorSubject<int> _daysAgoCalendar = BehaviorSubject.seeded(0);
  Stream<int> get daysAgoCalendarStream => _daysAgoCalendar.stream;
  int get daysAgoCalendar => _daysAgoCalendar.value;
  setDaysAgoCalendar(int daysAgo) {
    _daysAgoCalendar.add(daysAgo);
  }

  final BehaviorSubject<HISTORY_CATEGORY> _historyCategory =
      BehaviorSubject.seeded(HISTORY_CATEGORY.WORKOUTS);
  Stream<HISTORY_CATEGORY> get historyCategoryStream => _historyCategory.stream;
  HISTORY_CATEGORY get historyCategory => _historyCategory.value;
  setHistoryCategory(HISTORY_CATEGORY category) {
    _historyCategory.add(category);
  }
}

HisotryController historyController = HisotryController();
