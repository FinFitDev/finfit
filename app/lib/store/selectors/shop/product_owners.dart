import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';

ContentWithLoading<Map<String, IProductOwnerEntry>> getSearchProductOwners(
    ContentWithLoading<Map<String, IProductOwnerEntry>> data, String search) {
  final filteredEntries = data.content.entries
      .where((entry) =>
          entry.value.name.toLowerCase().contains(search.toLowerCase()))
      .toList();

  final sortedContent =
      Map<String, IProductOwnerEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}
