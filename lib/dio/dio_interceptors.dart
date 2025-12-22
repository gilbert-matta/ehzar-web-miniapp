import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptors extends Interceptor {
  DioInterceptors();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint("${options.method} ${options.path}");
    // Load your token here and pass to the header
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.get("token");
    debugPrint("token: $token");
    options.sendTimeout = const Duration(seconds: 30);
    options.receiveTimeout = const Duration(seconds: 30);
    options.followRedirects = false;
    options.validateStatus = (status) => true;
    options.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    // debugPrint("11111111111111");

    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    debugPrint("${response.data}");
    debugPrint("onResponseeee");

    if (response.statusCode != null &&
        (response.statusCode! < 200 || response.statusCode! > 399)) {
      debugPrint("errorrrrrrrrrrr: ${response.statusCode}");
      // Handle the error here
      return handler.reject(
        DioException(
          response: Response(
              statusCode: response.statusCode,
              requestOptions: RequestOptions(path: ''),
              data: response.data),
          error: '${response.data}',
          requestOptions: RequestOptions(path: ''),
        ),
      );
    }

    return handler.next(response);
  }

  @override
  Future<dynamic> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // debugPrint("dio error");
    // debugPrint(err.message);
    // debugPrint("${err.type}");
    // debugPrint("${err.response?.statusCode}");

    return handler.next(err);
  }
}
