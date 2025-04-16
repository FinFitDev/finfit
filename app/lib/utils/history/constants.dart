import 'package:excerbuys/types/enums.dart';

final List<Map<String, dynamic>> HISTORY_CATEGORY_BUTTONS = [
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
