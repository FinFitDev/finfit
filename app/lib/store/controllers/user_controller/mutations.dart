part of 'user_controller.dart';

extension UserControllerMutations on UserController {
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
}
