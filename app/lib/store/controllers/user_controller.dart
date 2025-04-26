import 'dart:convert';
import 'dart:math';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/user.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:rxdart/rxdart.dart';

class UserController {
  final BehaviorSubject<User?> _currentUser = BehaviorSubject.seeded(null);
  Stream<User?> get currentUserStream => _currentUser.stream;
  User? get currentUser => _currentUser.value;
  setCurrentUser(User? user, {bool saveToStorage = true}) {
    if (user != null) {
      _currentUser.add(user);
      if (saveToStorage) {
        storageController.saveStateLocal(CURRENT_USER_KEY, user.toString());
      }
    }
  }

  updateUserImage(String image) {
    final updatedUser = currentUser?.copyWith(image: image);
    setCurrentUser(updatedUser);
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
        // don't save to storage again
        setCurrentUser(User.fromMap(jsonDecode(currentUserSaved)),
            saveToStorage: false);
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  // ran only after login/sign up or on refresh
  Future<User?> getCurrentUser(String userId) async {
    try {
      final User? user = await fetchUserByIdRequest(userId, null);
      if (user != null) {
        setCurrentUser(user);
      }
      return user;
    } catch (err) {
      return null;
    }
  }

  Future<bool> fetchUpdateUserImage(String? imageSeed) async {
    try {
      if (currentUser == null || imageSeed == null) {
        return false;
      }

      final bool successfulUpdate =
          await updateUserImageRequest(currentUser!.uuid, imageSeed);

      if (successfulUpdate == true) {
        updateUserImage(imageSeed);
        return true;
      }
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updateUserPointsScore(int pointsToAdd) async {
    if (currentUser != null && pointsToAdd > 0) {
      final bool updateResult =
          await updatePointsScoreRequest(currentUser!.uuid, pointsToAdd);

      return updateResult;
    } else {
      return Future.value(false);
    }
  }

  Future<bool> updateUserPointsScoreAndTimestamp(int pointsToAdd) async {
    if (currentUser != null && pointsToAdd > 0) {
      final bool updateResult =
          await updatePointsScoreWithUpdateTimestampRequest(
              currentUser!.uuid, pointsToAdd);

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
