import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<dynamic> handleBackendRequests(
    {required String endpoint,
    required HTTP_METHOD method,
    Map<String, String>? headers,
    Object? body,
    CancelToken? cancelToken}) async {
  String accessToken = authController.accessToken;
  final String refreshToken = authController.refreshToken;

  // if we want to query the api, check the validity of the access token
  if (endpoint.split("/").contains("api")) {
    final response = await httpHandler(
        url: "$BACKEND_BASE_URL$endpoint",
        method: method,
        headers: {...(headers ?? {}), "authorization": "Bearer $accessToken"},
        body: body,
        cancelToken: cancelToken);

    if (response['error'] == "You are not authorized" ||
        response["error"] == "Token invalid or expired") {
      // // verify access token
      // final dynamic verifyResponse = await httpHandler(
      //     url: "${BACKEND_BASE_URL}auth/verify",
      //     method: HTTP_METHOD.POST,
      //     body: {"access_token": accessToken});

      // throw if we cant refresh
      if (refreshToken.isEmpty) {
        throw Exception("Invalid refresh token");
      }
      // refresh access token if its expired
      final dynamic refreshResponse = await httpHandler(
          url: "${BACKEND_BASE_URL}auth/refresh",
          method: HTTP_METHOD.POST,
          body: {"refresh_token": refreshToken});

      final String? newAccessToken = refreshResponse['access_token'];
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        authController.setAccessToken(refreshResponse['access_token']);
        accessToken = newAccessToken;
      }

      return await httpHandler(
          url: "$BACKEND_BASE_URL$endpoint",
          method: method,
          headers: {...(headers ?? {}), "authorization": "Bearer $accessToken"},
          body: body,
          cancelToken: cancelToken);
    }

    return response;
  }

  return await httpHandler(
      url: "$BACKEND_BASE_URL$endpoint",
      method: method,
      headers: headers,
      body: body,
      cancelToken: cancelToken);
}
