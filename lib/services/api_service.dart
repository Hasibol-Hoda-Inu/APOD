import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });
}

class NetworkCaller {
  Future<NetworkResponse> getRequest(String url) async {
    try {
      Map<String, String> headers = {"content-type": "application/json"};
      Uri uri = Uri.parse(url);

      Response response = await get(uri, headers: headers);

      int statusCode = response.statusCode;
      String body = response.body;

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        debugPrint("✅ Success Status: $statusCode");
        debugPrint("✅ Response Body: $body");

        return NetworkResponse(
          isSuccess: true,
          statusCode: 200,
          responseData: decodedData,
        );
      } else {
        debugPrint("❎ Fail Status: $statusCode");
        debugPrint("❎ Response Body: $body");

        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Try again",
        );
      }
    } catch (e) {
      debugPrint("❎ ${e.toString()}");
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
