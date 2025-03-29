import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/auth/requests.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:rxdart/rxdart.dart';

enum AUTH_METHOD { LOGIN, SIGNUP }

class AuthController {
  final BehaviorSubject<AUTH_METHOD> _activeAuthMethod =
      BehaviorSubject.seeded(AUTH_METHOD.LOGIN);
  Stream<AUTH_METHOD> get activeAuthMethodStream => _activeAuthMethod.stream;
  AUTH_METHOD get activeAuthMethod => _activeAuthMethod.value;
  setActiveAuthMethod(AUTH_METHOD method) {
    _activeAuthMethod.add(method);
  }

  // access token state
  final BehaviorSubject<String> _accessToken = BehaviorSubject.seeded('');
  Stream<String> get accessTokenStream => _accessToken.stream;
  String get accessToken => _accessToken.value;
  setAccessToken(String val) {
    _accessToken.add(val);
    storageController.saveStateLocal(ACCESS_TOKEN_KEY, val);
  }

  // refresh token state
  final BehaviorSubject<String> _refreshToken = BehaviorSubject.seeded('');
  Stream<String> get refreshTokenStream => _refreshToken.stream;
  String get refreshToken => _refreshToken.value;
  setRefreshToken(String val) {
    _refreshToken.add(val);
    storageController.saveStateLocal(REFRESH_TOKEN_KEY, val);
  }

  // verify user is necessary
  final BehaviorSubject<UserToVerify?> _userToVerify =
      BehaviorSubject.seeded(null);
  Stream<UserToVerify?> get userToVerifyStream => _userToVerify.stream;
  UserToVerify? get userToVerify => _userToVerify.value;
  setUserToVerify(UserToVerify? userId) {
    _userToVerify.add(userId);
  }

  final BehaviorSubject<ResetPasswordUser?> _resetPasswordUser =
      BehaviorSubject.seeded(null);
  Stream<ResetPasswordUser?> get resetPasswordUserStream =>
      _resetPasswordUser.stream;
  ResetPasswordUser? get resetPasswordUser => _resetPasswordUser.value;
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

AuthController authController = AuthController();
