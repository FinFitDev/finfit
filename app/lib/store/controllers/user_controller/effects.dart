part of 'user_controller.dart';

extension UserControllerEffects on UserController {
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

      print(updateResult);

      if (updateResult) {
        print('update resulr');
        setUserUpdatedAt(DateTime.now());
      }
      return updateResult;
    } else {
      return Future.value(false);
    }
  }
}
