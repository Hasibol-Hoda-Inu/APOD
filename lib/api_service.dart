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

class NetworkCaller{
  Future<NetworkResponse> getRequest(
      String url,
      // {Map<String, dynamic>? queryParams, String? accessToken}
      )async{
    try{
      Map<String, String> headers = {
        "content-type" : "application/json"
      };

      // if(accessToken != null){
      //   headers["token"] = accessToken;
      // }

      // if(queryParams != null){
      //   url += "?";
      //   for(String param in queryParams.keys){
      //     url+= "$param=${queryParams[param]}&";
      //   }
      // }

      Uri uri = Uri.parse(url);

      Response response = await get(uri, headers: headers);
      final decodedData = jsonDecode(response.body);

      if(response.statusCode == 200){
        debugPrint("✅ Success");
        return NetworkResponse(isSuccess: true, statusCode: 200, responseData: decodedData);
      }else{
       return NetworkResponse(isSuccess: false, statusCode: response.statusCode, errorMessage: "Try again");
      }
    }catch(e){
      debugPrint("❎ ${e.toString()}");
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }
}