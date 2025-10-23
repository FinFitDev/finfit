enum RECENT_DATA_CATEGORY { TRANSACTIONS, WORKOUTS }

enum STEPS_AGGREGATION_TYPE { HOURLY, DAILY, MONTHLY }

enum STEPS_AGGREGATION_VALUE { TOTAL, MEAN }

enum HISTORY_CATEGORY { WORKOUTS, TRANSACTIONS }

enum SEND_MODAL_STEPS { CHOOSE_RECIPIENTS, SCAN_QR, AMOUNT_AND_CONFIRM }

enum RESET_PASSWORD_ERROR { WRONG_EMAIL, SERVER_ERROR }

enum PRODUCT_CATEGORY {
  UNKNOWN,
  FOOD,
  MEMBERSHIPS,
  EQUIPMENT,
  EVENTS,
  SUPPLEMENTS
}

enum TRANSACTION_TYPE { REDEEM, SEND, RECEIVE, UNKNOWN }

enum SORTING_ORDER { ASCENDING, DESCENDING }

enum AUTH_METHOD { LOGIN, SIGNUP }

enum ACTIVITY_TYPE {
  Walk,
  Run,
  Ride,
  Swim;

  // Convert enum to string
  String get value {
    switch (this) {
      case ACTIVITY_TYPE.Walk:
        return 'Walk';
      case ACTIVITY_TYPE.Run:
        return 'Run';
      case ACTIVITY_TYPE.Ride:
        return 'Ride';
      case ACTIVITY_TYPE.Swim:
        return 'Swim';
    }
  }

  // Convert string to enum
  static ACTIVITY_TYPE fromString(String value) {
    switch (value) {
      case 'Walk':
        return ACTIVITY_TYPE.Walk;
      case 'Run':
        return ACTIVITY_TYPE.Run;
      case 'Ride':
        return ACTIVITY_TYPE.Ride;
      case 'Swim':
        return ACTIVITY_TYPE.Swim;
      default:
        throw ArgumentError('Invalid activity type: $value');
    }
  }

  // Safe conversion with fallback
  static ACTIVITY_TYPE? tryFromString(String? value) {
    if (value == null) return null;
    try {
      return fromString(value);
    } catch (_) {
      return null;
    }
  }
}
