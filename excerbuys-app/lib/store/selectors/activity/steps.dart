import 'package:excerbuys/types/general.dart';

ContentWithLoading<Map<int, int>> parseStepsChart(
    ContentWithLoading<Map<String, int>> contentWithLoading) {
  Map<int, int> hourlySteps = {for (int i = 0; i < 24; i++) i: 0};

  for (var entry in contentWithLoading.content.entries) {
    int hour = DateTime.parse(entry.key).hour;
    hourlySteps[hour] = (hourlySteps[hour] ?? 0) + entry.value;
  }

  return ContentWithLoading<Map<int, int>>(
    content: hourlySteps,
  );
}
