import 'package:excerbuys/utils/utils.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

Map<String, HealthDataPoint> checkActivityData(
    Map<String, HealthDataPoint> activity) {
  // Filter out entries where the numeric value is <= 1 and sort from the most recent to the oldest
  // we also refactor the data so that the workout and calories burned data dont overlap
  var sortedActivity = Map.fromEntries(
    activity.entries.where((entry) {
      final currentValue = entry.value;
      final bool isCorrespondingWorkout = activity.values.any((point) =>
          areDatesEqualRespectToMinutes(
              currentValue.dateFrom, point.dateFrom) &&
          areDatesEqualRespectToMinutes(currentValue.dateTo, point.dateTo) &&
          point.value is WorkoutHealthValue &&
          point.uuid != currentValue.uuid);
      final bool nonZeroData = currentValue.value is NumericHealthValue
          ? (currentValue.value as NumericHealthValue).numericValue >= 1
          : ((currentValue.value as WorkoutHealthValue).totalEnergyBurned ??
                  0) >=
              1;
      return nonZeroData && !isCorrespondingWorkout;
    }).toList()
      ..sort((a, b) => b.value.dateTo.compareTo(a.value.dateTo)),
  );

  return sortedActivity;
}

bool areDatesEqualRespectToMinutes(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day &&
      date1.hour == date2.hour &&
      date1.minute == date2.minute;
}
