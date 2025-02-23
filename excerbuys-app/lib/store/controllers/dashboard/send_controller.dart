import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/app_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/activity/trainings.dart';
import 'package:excerbuys/utils/home/send.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

const TRAINING_DATA_CHUNK_SIZE = 5;

class SendController {
  CancelToken cancelToken = CancelToken();

  final BehaviorSubject<ContentWithLoading<Map<String, User>>> _userList =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, User>>> get userListStream =>
      _userList.stream.map((data) {
        final sortedContent = Map.fromEntries(data.content.entries.toList()
          ..sort((a, b) => a.value.username.compareTo(b.value.username)));

        return data.copyWith(content: sortedContent);
      });

  ContentWithLoading<Map<String, User>> get userList => _userList.value;

  Stream<ContentWithLoading<Map<String, User>>> get usersForSearchStream =>
      _userList.stream.map((data) {
        final Map<String, User> filteredContent = {
          for (var entry in data.content.entries.where((user) {
            if (user.key == userController.currentUser?.id) {
              return false;
            }
            if (searchValue == null || searchValue!.isEmpty) {
              return true;
            }

            return user.value.username
                .toLowerCase()
                .contains(searchValue!.toLowerCase());
          }))
            entry.key: entry.value
        };

        return data.copyWith(content: filteredContent);
      });

  Stream<ContentWithLoading<Map<String, User>>> get selectedUsersStream =>
      _userList.stream.map((data) {
        final Map<String, User> filteredContent = {
          for (var entry in data.content.entries.where((user) {
            if (user.key == userController.currentUser?.id) {
              return false;
            }
            return chosenUsersIds.contains(user.value.id);
          }))
            entry.key: entry.value
        };

        return data.copyWith(content: filteredContent);
      });

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

  final BehaviorSubject<String?> _searchValue = BehaviorSubject.seeded(null);
  Stream<String?> get searchValueStream => _searchValue.stream;
  String? get searchValue => _searchValue.value;

  // its debounced so we can fetch on update
  setSearchValue(String? value) {
    if (userList.isLoading) cancelToken.cancel();
    _searchValue.add(value);
    cancelToken = CancelToken();
    fetchUsersForSearch();
  }

  final BehaviorSubject<List<String>> _chosenUsersIds =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get chosenUsersIdsStream => _chosenUsersIds.stream;
  List<String> get chosenUsersIds => _chosenUsersIds.value;

  proccessSelectUser(String userId) {
    if (chosenUsersIds.contains(userId)) {
      _chosenUsersIds.add(chosenUsersIds.where((id) => id != userId).toList());
    } else {
      _chosenUsersIds.add([...chosenUsersIds, userId]);
    }
  }

  Future<void> fetchUsersForSearch() async {
    if (searchValue == null || searchValue!.isEmpty) {
      return;
    }

    setListLoading(true);
    try {
      List<User> foundUsers =
          await loadUsers(searchValue!, 8, 0, cancelToken) ?? [];

      Set<String> unique = {};
      foundUsers =
          foundUsers.where((element) => unique.add(element.id)).toList();

      Map<String, User> values = {
        for (var el in foundUsers) el.id: el,
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
      User? foundUser = await loadUserForId(userId, cancelToken);

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
}

SendController sendController = SendController();
