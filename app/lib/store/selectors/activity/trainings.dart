import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/utils.dart';

ContentWithLoading<Map<int, ITrainingEntry>> getSortedRecentTrainings(
  ContentWithLoading<Map<int, ITrainingEntry>> all,
) {
  final sortedWorkouts = getTopRecentEntries(
      all.content, (a, b) => b.value.createdAt.compareTo(a.value.createdAt), 5);
  final ContentWithLoading<Map<int, ITrainingEntry>> response =
      ContentWithLoading(content: sortedWorkouts);
  response.isLoading = all.isLoading;
  return response;
}
