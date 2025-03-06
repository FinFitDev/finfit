import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/send.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/home/send/requests.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SendController {
  CancelToken cancelToken = CancelToken();

  final BehaviorSubject<ContentWithLoading<Map<String, User>>> _userList =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));

  Stream<ContentWithLoading<Map<String, User>>> get userListStream =>
      _userList.stream;

  ContentWithLoading<Map<String, User>> get userList => _userList.value;

  Stream<ContentWithLoading<Map<String, User>>> get usersForSearchStream =>
      Rx.combineLatest3(userListStream, searchValueStream,
          recentRecipientsIdsStream, getUsersForSearch);

  Stream<ContentWithLoading<Map<String, User>>> get selectedUsersStream =>
      Rx.combineLatest2(userListStream, chosenUsersIdsStream, getSelectedUsers);

  final BehaviorSubject<String?> _searchValue = BehaviorSubject.seeded(null);
  Stream<String?> get searchValueStream => _searchValue.stream;
  String? get searchValue => _searchValue.value;

// for optimization (dont fetch the same endpoint multiple times)
  final BehaviorSubject<List<String>> _alreadyFetchedQueries =
      BehaviorSubject.seeded([]);
  List<String> get alreadyFetchedQueries => _alreadyFetchedQueries.value;

  final BehaviorSubject<List<String>> _chosenUsersIds =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get chosenUsersIdsStream => _chosenUsersIds.stream;
  List<String> get chosenUsersIds => _chosenUsersIds.value;

  final BehaviorSubject<List<String>> _recentRecipientsIds =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get recentRecipientsIdsStream =>
      _recentRecipientsIds.stream;
  List<String> get recentRecipientsIds => _recentRecipientsIds.value;

  final BehaviorSubject<int?> _amount = BehaviorSubject.seeded(null);
  Stream<int?> get amountStream => _amount.stream;
  int? get amount => _amount.value;

  Stream<int> get totalAmountStream =>
      Rx.combineLatest2(chosenUsersIdsStream, amountStream, getTotalAmount);

  resetUi() {
    _amount.add(null);
    _searchValue.add(null);
    _chosenUsersIds.add([]);
  }

  clearUserList() {
    final ContentWithLoading<Map<String, User>> newData =
        ContentWithLoading(content: {});
    newData.isLoading = false;
    _userList.add(newData);
  }

  setUserList(Map<String, User> users) {
    _userList.add(ContentWithLoading(content: users));
  }

  addUsersToList(Map<String, User> users) {
    Map<String, User> newList = {...userList.content, ...users};
    final newData = ContentWithLoading(content: newList);
    newData.isLoading = userList.isLoading;
    _userList.add(newData);
  }

  setListLoading(bool loading) {
    userList.isLoading = loading;
    _userList.add(userList);
  }

  // its debounced so we can fetch on update
  setSearchValue(String? value) {
    if (userList.isLoading) cancelToken.cancel();
    _searchValue.add(value != null && value.isEmpty ? null : value);
    cancelToken = CancelToken();
    fetchUsersForSearch();
  }

  setAmount(int? amount) {
    _amount.add(amount);
  }

  proccessSelectUser(String userId) {
    if (chosenUsersIds.contains(userId)) {
      _chosenUsersIds.add(chosenUsersIds.where((id) => id != userId).toList());
    } else {
      _chosenUsersIds.add([...chosenUsersIds, userId]);
    }
  }

  addFetchedQuery(String query) {
    if (!alreadyFetchedQueries.contains(query)) {
      _alreadyFetchedQueries.add([...alreadyFetchedQueries, query]);
    }
  }

  setRecentRecipientsIds(List<String> ids) {
    _recentRecipientsIds.add(ids);
  }

  loadRecentRecipients() async {
    final response =
        await storageController.loadStateLocal(RECENT_RECIPIENTS_KEY);
    if (response != null) {
      final Map<String, User> userMap = {
        for (final user
            in (jsonDecode(response) as Map<String, dynamic>).entries)
          user.key: UserItem.fromMap(jsonDecode(user.value)).user
      };

      if (userMap.isNotEmpty) {
        addUsersToList(userMap);
        setRecentRecipientsIds(userMap.keys.toList());
      }
    }
    setListLoading(false);
  }

  saveRecentRecipients() async {
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
      ...currentSelected.map((key, value) => MapEntry(
          key,
          UserItem(
              user: value,
              timestamp: DateTime.now()))), // Assign timestamp to new users
      ...fromStorage
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
    }
  }

  Future<void> fetchUsersForSearch() async {
    if (searchValue == null ||
        searchValue!.isEmpty ||
        alreadyFetchedQueries.contains((searchValue))) {
      return;
    }

    setListLoading(true);
    try {
      List<User> foundUsers =
          await loadSendUsersRequest(searchValue!, 10, 0, cancelToken) ?? [];

      Set<String> unique = {};
      foundUsers =
          foundUsers.where((element) => unique.add(element.id)).toList();

      Map<String, User> values = {
        for (var el in foundUsers) el.id: el,
      };

      addUsersToList(values);
      // we only add the query if it was successful
      addFetchedQuery(searchValue!);
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
        addUsersToList({foundUser.id: foundUser});
        if (!chosenUsersIds.contains(foundUser.id)) {
          proccessSelectUser(foundUser.id);
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
      if (userController.currentUser?.id == null ||
          chosenUsersIds.isEmpty ||
          totalAmount <= 0) {
        throw 'Invalid data';
      }

      await Future.delayed(Duration(seconds: 1));

      int? remainingPoints = await resolveSendPointsRequest(
          userController.currentUser!.id, chosenUsersIds, totalAmount);

      if (remainingPoints != null) {
        userController.setUserBalance(remainingPoints.toDouble());
      }
    } catch (error) {
      debugPrint("Exception while sending points: $error");
    }
  }
}

SendController sendController = SendController();
