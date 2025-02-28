import 'dart:io';

import 'package:excerbuys/containers/auth_page/login_container.dart';
import 'package:excerbuys/containers/auth_page/signup_container.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/utils/auth/requests.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
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
    storageController.saveStateLocal('access_token', val);
  }

  // refresh token state
  final BehaviorSubject<String> _refreshToken = BehaviorSubject.seeded('');
  Stream<String> get refreshTokenStream => _refreshToken.stream;
  String get refreshToken => _refreshToken.value;
  setRefreshToken(String val) {
    _refreshToken.add(val);
    storageController.saveStateLocal('refresh_token', val);
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

  Future<Map<LOGIN_FIELD_TYPE, String?>?> logIn(
      String login, String password) async {
    try {
      final {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user_id': userId
      } = await logInRequest(login, password);

      if (accessToken.isNotEmpty) {
        setAccessToken(accessToken);
        await userController.getCurrentUser(userId);
      }
      if (refreshToken.isNotEmpty) {
        setRefreshToken(refreshToken);
      }
      return null;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Map<SIGNUP_FIELD_TYPE, String?>?> signUp(
      String username, String email, String password) async {
    try {
      final String message = await signUpRequest(username, email, password);

      if (message == "Sign up successful") {
        await logIn(username, password);
      }
      return null;
    } catch (error) {
      print(error);
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
}

AuthController authController = AuthController();
