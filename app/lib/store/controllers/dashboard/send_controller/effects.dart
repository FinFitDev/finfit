part of 'send_controller.dart';

extension SendControllerEffects on SendController {
  loadRecentRecipients() async {
    final response =
        await storageController.loadStateLocal(RECENT_RECIPIENTS_KEY);
    if (response != null) {
      final Map<String, User> userMap = {
        for (final entry
            in (jsonDecode(response) as Map<String, dynamic>).entries)
          if (UserItem.fromMap(jsonDecode(entry.value)).user.uuid !=
              userController.currentUser?.uuid)
            entry.key: UserItem.fromMap(jsonDecode(entry.value)).user,
      };
      if (userMap.isNotEmpty) {
        addUsersToList(userMap);
        setRecentRecipientsIds(userMap.keys.toList());
      }
    }
    setListLoading(false);
  }

  saveRecentRecipients({overwriteTimestamps = true}) async {
    final Map<String, User> currentSelected =
        (await selectedUsersStream.first).content;

    final response =
        await storageController.loadStateLocal(RECENT_RECIPIENTS_KEY);

    Map<String, UserItem> fromStorage = {};
    if (response != null) {
      fromStorage = {
        for (final user
            in (jsonDecode(response) as Map<String, dynamic>).entries)
          user.key: UserItem.fromMap(jsonDecode(user.value))
      };
    }

    final mergedMap = {
      ...fromStorage,
      for (final entry in currentSelected.entries)
        entry.key: UserItem(
          user: entry.value,
          timestamp: overwriteTimestamps
              ? DateTime.now()
              : fromStorage[entry.key]?.timestamp ?? DateTime.now(),
        ),
    };

    final sortedEntries = mergedMap.entries.toList()
      ..sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));

    final Map<String, UserItem> userMap = {
      for (var entry in [...sortedEntries.take(10)]) entry.key: entry.value
    };

    if (userMap.isNotEmpty) {
      await storageController.saveStateLocal(
          RECENT_RECIPIENTS_KEY,
          jsonEncode({
            for (var user in userMap.entries) user.key: user.value.toString()
          }));
      await loadRecentRecipients();
    }
  }

  Future<void> fetchUsersForSearch() async {
    if (searchValue == null || searchValue!.isEmpty) {
      return;
    }

    setListLoading(true);
    try {
      List<User> foundUsers =
          await loadSendUsersRequest(searchValue!, [], 10, 0, cancelToken) ??
              [];

      Set<String> unique = {};
      foundUsers =
          foundUsers.where((element) => unique.add(element.uuid)).toList();

      Map<String, User> values = {
        for (var el in foundUsers) el.uuid: el,
      };

      addUsersToList(values);
    } catch (error) {
      debugPrint("Exception while fetching users data: $error");
    } finally {
      setListLoading(false);
    }
  }

// on refresh and cache clear we need to refetch recent users
  Future<void> refetchRecentUsers() async {
    if (recentRecipientsIds.isEmpty) {
      return;
    }
    setListLoading(true);
    try {
      List<User> foundUsers = await loadSendUsersRequest(
              "", recentRecipientsIds, 10, 0, cancelToken) ??
          [];

      Set<String> unique = {};
      foundUsers =
          foundUsers.where((element) => unique.add(element.uuid)).toList();

      Map<String, User> values = {
        for (var el in foundUsers) el.uuid: el,
      };

      addUsersToList(values);
    } catch (error) {
      debugPrint("Exception while fetching users data: $error");
    } finally {
      setListLoading(false);
    }
  }

  Future<void> fetchQrCodeUser(String userId) async {
    try {
      User? foundUser = await fetchUserByIdRequest(userId, cancelToken);

      if (foundUser != null) {
        addUsersToList({foundUser.uuid: foundUser});
        if (!chosenUsersIds.contains(foundUser.uuid)) {
          proccessSelectUser(foundUser.uuid);
        }
      }
    } catch (error) {
      debugPrint("Exception while fetching users data: $error");
    } finally {
      setListLoading(false);
    }
  }

  Future<void> sendPoints() async {
    try {
      final totalAmount = await totalAmountStream.first;
      if (userController.currentUser?.uuid == null ||
          chosenUsersIds.isEmpty ||
          totalAmount <= 0) {
        throw 'Invalid data';
      }

      await Future.delayed(Duration(milliseconds: 2000)); // TODO remove

      int? remainingPoints = await resolveSendPointsRequest(
          userController.currentUser!.uuid, chosenUsersIds, totalAmount);

      if (remainingPoints != null) {
        userController.setUserBalance(remainingPoints.toDouble());
        transactionsController.refresh();
      }
    } catch (error) {
      debugPrint("Exception while sending points: $error");
    }
  }
}
