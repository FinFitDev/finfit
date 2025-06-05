part of 'user_controller.dart';

extension UserControllerSelectors on UserController {
  Stream<double?> get userBalanceStream => currentUserStream.map(getBalance);
  double? get userBalance => getBalance(currentUser);
}
