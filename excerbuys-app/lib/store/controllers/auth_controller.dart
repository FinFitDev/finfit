import 'dart:io';

import 'package:excerbuys/containers/auth_page/login_container.dart';
import 'package:excerbuys/containers/auth_page/signup_container.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
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
      dynamic res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'auth/login',
          body: {"login": login, "password": password});

      if (res['error'] != null) {
        if (res['type'] == 'login') {
          return {LOGIN_FIELD_TYPE.LOGIN: res['error']};
        }
        if (res['type'] == 'password') {
          return {LOGIN_FIELD_TYPE.PASSWORD: res['error']};
        }
        // should not reach here
        throw Exception(res['message']);
      }

      final {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user_id': userId
      } = res['content'];

      if (accessToken.isNotEmpty) {
        setAccessToken(accessToken);
        await userController.fetchCurrentUser(userId);
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
      dynamic res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'auth/signup',
          body: {"username": username, "password": password, "email": email});

      if (res['error'] != null) {
        if (res['type'] == 'username') {
          return {SIGNUP_FIELD_TYPE.USERNAME: res['error']};
        }
        if (res['type'] == 'email') {
          return {SIGNUP_FIELD_TYPE.EMAIL: res['error']};
        }
        // should not reach here
        throw Exception(res['message']);
      }

      if (res['message'] == "Sign up successful") {
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
      dynamic res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'auth/logout',
          body: {"refresh_token": refreshToken});

      if (res['error'] != null) {
        throw Exception(res['error']);
      }

      if (res['message'] == 'Logout successful') {
        authController.setAccessToken('');
        authController.setRefreshToken('');
        userController.setCurrentUser(null);
      }

      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<String?> useGoogleAuth(String id_token) async {
    try {
      dynamic res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'auth/googleAuth',
          body: {
            "id_token": id_token,
            "platform": Platform.isIOS
                ? 'ios'
                : 'android' // different backend token for platforms
          });

      if (res['error'] != null) {
        // should not reach here
        throw Exception(res['message']);
      }

      print(res);

      final {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user_id': userId
      } = res['content'];

      if (accessToken.isNotEmpty) {
        setAccessToken(accessToken);
        await userController.fetchCurrentUser(userId);
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
}

AuthController authController = AuthController();
