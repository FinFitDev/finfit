import 'dart:convert';

import 'package:dio/dio.dart';

enum HTTP_METHOD { GET, POST, PUT, PATCH, DELETE }

final options = BaseOptions(
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  validateStatus: (status) {
    return true;
  },
);
final dio = Dio(options);
Future<dynamic> httpHandler({
  required String url,
  required HTTP_METHOD method,
  Map<String, String>? headers,
  Object? body,
  CancelToken? cancelToken,
}) async {
  final mergedHeaders = {
    "Content-Type": "application/json",
    ...?headers, // merge optional headers
  };

  Object? dataToSend = body;

  // Only encode body if it's a Map or List
  if (body is Map || body is List) {
    dataToSend = jsonEncode(body);
  }

  final Response response;

  switch (method) {
    case HTTP_METHOD.POST:
      response = await dio.post(
        url,
        options: Options(headers: mergedHeaders),
        data: dataToSend,
        cancelToken: cancelToken,
      );
      break;
    case HTTP_METHOD.PUT:
      response = await dio.put(
        url,
        options: Options(headers: mergedHeaders),
        data: dataToSend,
        cancelToken: cancelToken,
      );
      break;
    case HTTP_METHOD.PATCH:
      response = await dio.patch(
        url,
        options: Options(headers: mergedHeaders),
        data: dataToSend,
        cancelToken: cancelToken,
      );
      break;
    case HTTP_METHOD.DELETE:
      response = await dio.delete(
        url,
        options: Options(headers: mergedHeaders),
        data: dataToSend,
        cancelToken: cancelToken,
      );
      break;
    case HTTP_METHOD.GET:
    default:
      response = await dio.get(
        url,
        options: Options(headers: mergedHeaders),
        cancelToken: cancelToken,
      );
      break;
  }

  return response.data;
}
