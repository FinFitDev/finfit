import 'dart:io';

import 'package:excerbuys/containers/auth_page/login_container.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/containers/auth_page/signup_container.dart';

Future<Map<String, dynamic>> logInRequest(String login, String password,
    {bool noEmail = false}) async {
  dynamic res = await handleBackendRequests(
      method: HTTP_METHOD.POST,
      endpoint: 'auth/login?no_email=${noEmail == true ? "true" : "false"}',
      body: {"login": login, "password": password});

  if (res['error'] != null) {
    if (res['type'] == 'login') {
      throw {LOGIN_FIELD_TYPE.LOGIN: res['error']};
    }
    if (res['type'] == 'password') {
      throw {LOGIN_FIELD_TYPE.PASSWORD: res['error']};
    }
    // should not reach here
    throw Exception(res['message']);
  }

  return res['content'];
}

Future<Map<String, dynamic>> signUpRequest(
    String username, String email, String password) async {
  dynamic res = await handleBackendRequests(
      method: HTTP_METHOD.POST,
      endpoint: 'auth/signup',
      body: {"username": username, "password": password, "email": email});

  if (res['error'] != null) {
    if (res['type'] == 'username') {
      throw {SIGNUP_FIELD_TYPE.USERNAME: res['error']};
    }
    if (res['type'] == 'email') {
      throw {SIGNUP_FIELD_TYPE.EMAIL: res['error']};
    }
    // should not reach here
    throw Exception(res['message']);
  }

  return res['content'];
}

Future<String?> resendVerificationEmailRequest(String userId) async {
  try {
    dynamic res = await handleBackendRequests(
      method: HTTP_METHOD.GET,
      endpoint: 'auth/signup/verify/resend?user_id=$userId',
    );

    if (res['error'] != null) {
      throw Exception(res['error']);
    }

    return res['content'];
  } catch (err) {
    print(err);
    return null;
  }
}

Future<String?> sendPasswordResetEmailRequest(String email) async {
  try {
    dynamic res = await handleBackendRequests(
      method: HTTP_METHOD.GET,
      endpoint: 'auth/login/reset/mail?email=$email',
    );
    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'];
  } catch (err) {
    rethrow;
  }
}

Future<bool?> verifyPasswordResetCodeRequest(String code, String userId) async {
  try {
    dynamic res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'auth/login/reset/verify',
        body: {"code": code, "user_id": userId});

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'];
  } catch (err) {
    rethrow;
  }
}

Future<String?> setNewPasswordRequest(String password, String userId) async {
  try {
    dynamic res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'auth/login/reset/new',
        body: {"password": password, "user_id": userId});

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'];
  } catch (err) {
    rethrow;
  }
}

Future<String?> logOutRequest(String refreshToken) async {
  try {
    dynamic res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'auth/logout',
        body: {"refresh_token": refreshToken});

    if (res['error'] != null) {
      throw Exception(res['error']);
    }

    return res['message'];
  } catch (err) {
    print(err);
    return null;
  }
}

Future<Map<String, dynamic>> googleAuthRequest(String idToken) async {
  dynamic res = await handleBackendRequests(
      method: HTTP_METHOD.POST,
      endpoint: 'auth/googleAuth',
      body: {
        "id_token": idToken,
        "platform": Platform.isIOS
            ? 'ios'
            : 'android' // different backend token for platforms
      });

  if (res['error'] != null) {
    // should not reach here
    throw Exception(res['message']);
  }

  return res['content'];
}
