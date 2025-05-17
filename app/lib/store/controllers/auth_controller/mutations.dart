part of 'auth_controller.dart';

extension AuthControllerMutations on AuthController {
  setActiveAuthMethod(AUTH_METHOD method) {
    _activeAuthMethod.add(method);
  }

  setAccessToken(String val) {
    _accessToken.add(val);
    storageController.saveStateLocal(ACCESS_TOKEN_KEY, val);
  }

  setRefreshToken(String val) {
    _refreshToken.add(val);
    storageController.saveStateLocal(REFRESH_TOKEN_KEY, val);
  }

  setUserToVerify(UserToVerify? userId) {
    _userToVerify.add(userId);
  }

  setResetPasswordEmail(ResetPasswordUser? newUser) {
    _resetPasswordUser.add(newUser);
  }

  restoreAuthStateFromStorage() async {
    try {
      final String? accessToken =
          await storageController.loadStateLocal(ACCESS_TOKEN_KEY);
      final String? refreshToken =
          await storageController.loadStateLocal(REFRESH_TOKEN_KEY);
      if (accessToken != null && accessToken.isNotEmpty) {
        setAccessToken(accessToken);
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        setRefreshToken(refreshToken);
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }
}
