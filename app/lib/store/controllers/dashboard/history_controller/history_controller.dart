import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:rxdart/rxdart.dart';

part 'mutations.dart';
part 'selectors.dart';

class HistoryController {
  final BehaviorSubject<RECENT_DATA_CATEGORY> _activeCategoryRecentData =
      BehaviorSubject.seeded(RECENT_DATA_CATEGORY.DAILY);
  Stream<RECENT_DATA_CATEGORY> get activeCategoryRecentDataStream =>
      _activeCategoryRecentData.stream;
  RECENT_DATA_CATEGORY get activeCategoryRecentData =>
      _activeCategoryRecentData.value;

  final BehaviorSubject<int> _daysAgoCalendar = BehaviorSubject.seeded(0);
  Stream<int> get daysAgoCalendarStream => _daysAgoCalendar.stream;
  int get daysAgoCalendar => _daysAgoCalendar.value;

  final BehaviorSubject<HISTORY_CATEGORY> _historyCategory =
      BehaviorSubject.seeded(HISTORY_CATEGORY.WORKOUTS);
  Stream<HISTORY_CATEGORY> get historyCategoryStream => _historyCategory.stream;
  HISTORY_CATEGORY get historyCategory => _historyCategory.value;
}

HistoryController historyController = HistoryController();
