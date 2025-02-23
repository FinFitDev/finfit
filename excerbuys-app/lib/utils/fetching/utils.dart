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

Future<dynamic> httpHandler(
    {required String url,
    required HTTP_METHOD method,
    Map<String, String>? headers,
    Object? body,
    CancelToken? cancelToken}) async {
  final Response? response;

  switch (method) {
    case HTTP_METHOD.POST:
      response = await dio.post(url,
          options: Options(
            headers: headers,
          ),
          data: body,
          cancelToken: cancelToken);
      break;
    case HTTP_METHOD.PUT:
      response = await dio.put(url,
          options: Options(
            headers: headers,
          ),
          data: body,
          cancelToken: cancelToken);
      break;
    case HTTP_METHOD.PATCH:
      response = await dio.patch(url,
          options: Options(
            headers: headers,
          ),
          data: body,
          cancelToken: cancelToken);
      break;
    case HTTP_METHOD.DELETE:
      response = await dio.delete(url,
          options: Options(
            headers: headers,
          ),
          data: body,
          cancelToken: cancelToken);
      break;
    case HTTP_METHOD.GET:
    // if method isnt passed we should use the get protocol
    default:
      response = await dio.get(url,
          options: Options(
            headers: headers,
          ),
          cancelToken: cancelToken);
      break;
  }

  return response.data;
}
