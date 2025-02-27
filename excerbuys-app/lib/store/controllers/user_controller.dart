import 'dart:convert';
import 'dart:math';

import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/user.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/user/user.dart';
import 'package:rxdart/rxdart.dart';

class UserController {
  final BehaviorSubject<User?> _currentUser = BehaviorSubject.seeded(null);
  Stream<User?> get currentUserStream => _currentUser.stream;
  User? get currentUser => _currentUser.value;
  setCurrentUser(User? user) {
    if (user != null) {
      _currentUser.add(user);
      storageController.saveStateLocal(CURRENT_USER_KEY, user.toString());
    }
  }

  Stream<double?> get userBalanceStream => currentUserStream.map(getBalance);
  double? get userBalance => getBalance(currentUser);
  setUserBalance(double newBalance) {
    if (currentUser != null) {
      setCurrentUser(currentUser!.copyWith(points: newBalance));
    }
  }

  addUserBalance(double toAdd) {
    if (currentUser != null) {
      setCurrentUser(currentUser!.copyWith(points: (userBalance ?? 0) + toAdd));
    }
  }

  subtractUserBalance(double toSubtract) {
    if (currentUser != null) {
      setCurrentUser(currentUser!
          .copyWith(points: max(0, (userBalance ?? 0) - toSubtract)));
    }
  }

  setUserUpdatedAt(DateTime updatedAt) {
    if (currentUser != null) {
      setCurrentUser(currentUser!.copyWith(stepsUpdatedAt: updatedAt));
    }
  }

  restoreCurrentUserStateFromStorage() async {
    try {
      final String? currentUserSaved =
          await storageController.loadStateLocal(CURRENT_USER_KEY);

      if (currentUserSaved != null && currentUserSaved.isNotEmpty) {
        setCurrentUser(User.fromMap(jsonDecode(currentUserSaved)));
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  // ran only after login/sign up or on refresh
  Future<User?> fetchCurrentUser(String userId) async {
    try {
      dynamic res = await handleBackendRequests(
          method: HTTP_METHOD.GET, endpoint: 'api/v1/users/$userId');

      final content = res['content'];

      if (content == null || content.isEmpty) {
        throw 'No data';
      }

      final User user = User(
          id: content['id'],
          email: content['email'],
          username: content['username'],
          createdAt: DateTime.parse(content['created_at']).toLocal(),
          stepsUpdatedAt: DateTime.parse(content['steps_updated_at']).toLocal(),
          points: (content['points'] as int).toDouble(),
          image: content['image']);

      setCurrentUser(user);

      return user;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<bool> updateUserPointsScore(int pointsToAdd) async {
    if (currentUser != null && pointsToAdd > 0) {
      final bool updateResult =
          await updatePointsScore(currentUser!.id, pointsToAdd);

      return updateResult;
    } else {
      return Future.value(false);
    }
  }

  Future<bool> updateUserPointsScoreAndTimestamp(int pointsToAdd) async {
    if (currentUser != null && pointsToAdd > 0) {
      final bool updateResult = await updatePointsScoreWithUpdateTimestamp(
          currentUser!.id, pointsToAdd);

      if (updateResult) {
        setUserUpdatedAt(DateTime.now());
      }
      return updateResult;
    } else {
      return Future.value(false);
    }
  }
}

UserController userController = UserController();
