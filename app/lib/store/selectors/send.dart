import 'dart:collection';

import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';

ContentWithLoading<Map<String, User>> getUsersForSearch(
  ContentWithLoading<Map<String, User>> data,
  String? search,
  List<String> recentRecipients,
) {
  final isSearching = search != null && search.isNotEmpty;

  final entries = data.content.entries.where((user) {
    if (user.key == userController.currentUser?.uuid) return false;

    if (!isSearching) {
      return recentRecipients.contains(user.key);
    }

    final usernameMatch =
        user.value.username.toLowerCase().contains(search.toLowerCase());
    final emailMatch =
        user.value.email.toLowerCase().contains(search.toLowerCase());

    return usernameMatch || emailMatch;
  });

  Iterable<MapEntry<String, User>> sortedEntries;

  if (!isSearching) {
    // Order by recentRecipients list
    sortedEntries = recentRecipients
        .where((id) => data.content.containsKey(id))
        .map((id) => MapEntry(id, data.content[id]!));
  } else {
    // Sort matches by most recent usage first if available
    final matchOrder = recentRecipients.toSet();
    sortedEntries = entries.toList()
      ..sort((a, b) {
        final aIndex = matchOrder.contains(a.key)
            ? recentRecipients.indexOf(a.key)
            : recentRecipients.length;
        final bIndex = matchOrder.contains(b.key)
            ? recentRecipients.indexOf(b.key)
            : recentRecipients.length;
        return aIndex.compareTo(bIndex);
      });
  }

  return data.copyWith(content: LinkedHashMap.fromEntries(sortedEntries));
}

ContentWithLoading<Map<String, User>> getSelectedUsers(
    ContentWithLoading<Map<String, User>> data, List<String> chosenIds) {
  final List<MapEntry<String, User>> filteredEntries = chosenIds
      .where((id) =>
          id != userController.currentUser?.uuid &&
          data.content.containsKey(id))
      .map((id) => MapEntry(id, data.content[id]!))
      .toList();

  final LinkedHashMap<String, User> sortedContent =
      LinkedHashMap.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}

int getTotalAmount(List<String> chosenIds, int? amount) {
  return chosenIds.length * (amount ?? 0);
}
