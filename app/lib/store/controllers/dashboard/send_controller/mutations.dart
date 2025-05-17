part of 'send_controller.dart';

extension SendControllerMutations on SendController {
  resetUi() {
    _amount.add(null);
    _searchValue.add(null);
    _chosenUsersIds.add([]);
  }

  refresh() async {
    // by clearing the cache we force a refetch
    await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/users'));
    // loadRecentRecipients();
    _chosenUsersIds.add(recentRecipientsIds);
    await refetchRecentUsers();
    // just update user data not the timestamps
    saveRecentRecipients(overwriteTimestamps: false);
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

  setRecentRecipientsIds(List<String> ids) {
    _recentRecipientsIds.add(ids);
  }
}
