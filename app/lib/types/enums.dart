import 'dart:ui';

enum LANGUAGE {
  ENGLISH(
    languageCode: 'en',
    displayTitle: 'English',
    icon: 'assets/svg/english.svg',
  ),
  SPANISH(
    languageCode: 'es',
    displayTitle: 'Español',
    icon: 'assets/svg/spanish.svg',
  ),
  POLISH(
    languageCode: 'pl',
    displayTitle: 'Polski',
    icon: 'assets/svg/polish.svg',
  );

  final String languageCode;
  final String displayTitle;
  final String icon;

  const LANGUAGE({
    required this.languageCode,
    required this.displayTitle,
    required this.icon,
  });

  Locale get locale => Locale(languageCode);

  static LANGUAGE fromCode(String code) {
    return LANGUAGE.values.firstWhere(
      (lang) => lang.languageCode == code,
      orElse: () => LANGUAGE.ENGLISH,
    );
  }
}

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
  AlpineSki,
  BackcountrySki,
  Badminton,
  Canoeing,
  Crossfit,
  EBikeRide,
  Elliptical,
  EMountainBikeRide,
  Golf,
  GravelRide,
  Handcycle,
  HighIntensityIntervalTraining,
  Hike,
  IceSkate,
  InlineSkate,
  Kayaking,
  Kitesurf,
  MountainBikeRide,
  NordicSki,
  Pickleball,
  Pilates,
  Racquetball,
  Ride,
  RockClimbing,
  RollerSki,
  Rowing,
  Run,
  Sail,
  Skateboard,
  Snowboard,
  Snowshoe,
  Soccer,
  Squash,
  StairStepper,
  StandUpPaddling,
  Surfing,
  Swim,
  TableTennis,
  Tennis,
  TrailRun,
  Velomobile,
  VirtualRide,
  VirtualRow,
  VirtualRun,
  Walk,
  WeightTraining,
  Wheelchair,
  Windsurf,
  Workout,
  Yoga,
  Other;

  String get value => toString().split('.').last;

  String get label => _toLabel(value);

  static String _toLabel(String text) {
    final spaced = text.replaceAllMapped(
        RegExp(r'(?<!^)([A-Z])'), (match) => ' ${match.group(1)}');
    return spaced
        .replaceAll('E Bike', 'E-bike')
        .replaceAll('E Mountain', 'E-mountain')
        .toLowerCase()
        .replaceFirstMapped(RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase());
  }

  static ACTIVITY_TYPE fromString(String value) {
    return ACTIVITY_TYPE.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ACTIVITY_TYPE.Other,
    );
  }

  static ACTIVITY_TYPE? tryFromString(String? value) {
    if (value == null) return null;
    return fromString(value);
  }
}
