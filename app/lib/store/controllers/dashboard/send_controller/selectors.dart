part of 'send_controller.dart';

extension SendControllerSelectors on SendController {
  Stream<ContentWithLoading<Map<String, User>>> get usersForSearchStream =>
      Rx.combineLatest3(userListStream, searchValueStream,
          recentRecipientsIdsStream, getUsersForSearch);

  Stream<ContentWithLoading<Map<String, User>>> get selectedUsersStream =>
      Rx.combineLatest2(userListStream, chosenUsersIdsStream, getSelectedUsers);

  Stream<int> get totalAmountStream =>
      Rx.combineLatest2(chosenUsersIdsStream, amountStream, getTotalAmount);
}
