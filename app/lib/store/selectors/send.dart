import 'dart:collection';

import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';

ContentWithLoading<Map<String, User>> getUsersForSearch(
    ContentWithLoading<Map<String, User>> data,
    String? search,
    List<String> recentRecipients) {
  final LinkedHashMap<String, User> filteredContent = LinkedHashMap.fromEntries(
    data.content.entries.where((user) {
      if (user.key == userController.currentUser?.uuid) {
        return false;
      }
      if (search == null || search.isEmpty) {
        return recentRecipients.contains(user.key);
      }
      return user.value.username.toLowerCase().contains(search.toLowerCase()) ||
          user.value.email.toLowerCase().contains(search.toLowerCase());
    }),
  );

  return data.copyWith(content: filteredContent);
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
