part of 'auth_controller.dart';

extension AuthControllerEffects on AuthController {
  Future<void> logIn(String login, String password,
      {bool noEmail = false}) async {
    try {
      setUserToVerify(null);
      final Map<String, dynamic> response =
          await logInRequest(login, password, noEmail: noEmail);
      final String? userId = response['user_id'];
      final String? accessToken = response['access_token'];
      final String? refreshToken = response['refresh_token'];

      if (userId != null && accessToken == null && refreshToken == null) {
        setUserToVerify(
            UserToVerify(userId: userId, login: login, password: password));
        return;
      }

      if (refreshToken?.isNotEmpty == true) {
        setRefreshToken(refreshToken!);
      }

      if (accessToken?.isNotEmpty == true) {
        setAccessToken(accessToken!);
        await userController.getCurrentUser(userId!);
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    try {
      setUserToVerify(null);
      final Map<String, dynamic> response =
          await signUpRequest(username, email, password);

      if (response['user_id'] != null) {
        setUserToVerify(UserToVerify(
            userId: response['user_id'], login: username, password: password));
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String userId) async {
    try {
      // returns user id
      final String? _ = await resendVerificationEmailRequest(userId);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> logOut() async {
    try {
      final String refreshToken = authController.refreshToken;
      final String? message = await logOutRequest(refreshToken);

      if (message == null) {
        throw 'Failed to log out';
      }

      if (message == 'Logout successful') {
        authController.setAccessToken('');
        authController.setRefreshToken('');
        userController.setCurrentUser(null);
      }

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<String?> useGoogleAuth(String idToken) async {
    try {
      final {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user_id': userId
      } = await googleAuthRequest(idToken);

      if (accessToken.isNotEmpty) {
        setAccessToken(accessToken);
        await userController.getCurrentUser(userId);
      }
      if (refreshToken.isNotEmpty) {
        setRefreshToken(refreshToken);
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  Future<RESET_PASSWORD_ERROR?> sendResetPassword(String email) async {
    try {
      // returns user id
      final String? userId = await sendPasswordResetEmailRequest(email);

      if (userId == null) {
        throw "Couldn't send";
      }

      setResetPasswordEmail(ResetPasswordUser(email: email, userId: userId));
      return null;
    } catch (error) {
      if (error == 'User not found') {
        return RESET_PASSWORD_ERROR.WRONG_EMAIL;
      } else {
        return RESET_PASSWORD_ERROR.SERVER_ERROR;
      }
    }
  }

  Future<bool?> verifyResetPasswordCode(String code) async {
    try {
      if (resetPasswordUser?.userId == null) {
        return null;
      }
      final bool? verified =
          await verifyPasswordResetCodeRequest(code, resetPasswordUser!.userId);

      return verified;
    } catch (error) {
      return null;
    }
  }

  Future<void> setNewPassword(String newPassword) async {
    if (resetPasswordUser?.userId == null) {
      throw 'Email not set';
    }
    final String? _ =
        await setNewPasswordRequest(newPassword, resetPasswordUser!.userId);

    return;
  }
}
