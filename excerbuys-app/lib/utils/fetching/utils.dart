import 'dart:convert';

import 'package:http/http.dart';

enum HTTP_METHOD { GET, POST, PUT, PATCH, DELETE }

class FetchingUtils {
  static Future<dynamic> httpHandler(
      {required String url,
      required HTTP_METHOD method,
      Map<String, String>? headers,
      Object? body}) async {
    final Response? response;
    Uri parsedUrl = Uri.parse(url);

    switch (method) {
      case HTTP_METHOD.POST:
        response = await post(parsedUrl, headers: headers, body: body);
        break;
      case HTTP_METHOD.PUT:
        response = await put(parsedUrl, headers: headers, body: body);
        break;
      case HTTP_METHOD.PATCH:
        response = await patch(parsedUrl, headers: headers, body: body);
        break;
      case HTTP_METHOD.DELETE:
        response = await delete(parsedUrl, headers: headers, body: body);
        break;
      case HTTP_METHOD.GET:
      // if method isnt passed we should use the get protocol
      default:
        response = await get(parsedUrl, headers: headers);
        break;
    }
    print(response.body);
    return jsonDecode(response.body);
  }
}
