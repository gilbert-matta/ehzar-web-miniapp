import 'package:ahzir/dio/dio_interceptors.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:dio/dio.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: myIP,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.add(DioInterceptors());
  }

  get(String uri, data) async {
    var response = await _dio.get(myIP + uri, queryParameters: data,
        options: Options(validateStatus: (status) {
      return status! >= 200 && status <= 399;
    }));
    return response;
  }

  post(String uri, data, [Map<String, dynamic>? headers]) async {
    var response = await _dio.post(myIP + uri, data: data, options: Options(
      validateStatus: (status) {
        if (status! >= 200 && status <= 399) {
          return true; // Response is considered valid
        } else {
          throw DioException(
            response: Response(
                statusCode: status, requestOptions: RequestOptions(path: '')),
            error: 'Request failed with status code $status',
            requestOptions: RequestOptions(path: uri),
          );
        }
      },
      headers: headers
    ));
    return response;
  }

  put(String uri, data) async {
    var response = await _dio.put(myIP + uri, data: data, options: Options(
      validateStatus: (status) {
        if (status! >= 200 && status <= 399) {
          return true; // Response is considered valid
        } else {
          throw DioException(
            response: Response(
                statusCode: status, requestOptions: RequestOptions(path: '')),
            error: 'Request failed with status code $status',
            requestOptions: RequestOptions(path: uri),
          );
        }
      },
    ));
    return response;
  }

  patch(String uri, data) async {
    var response = await _dio.patch(myIP + uri, data: data, options: Options(
      validateStatus: (status) {
        if (status! >= 200 && status <= 399) {
          return true; // Response is considered valid
        } else {
          throw DioException(
            response: Response(
                statusCode: status, requestOptions: RequestOptions(path: '')),
            error: 'Request failed with status code $status',
            requestOptions: RequestOptions(path: uri),
          );
        }
      },
    ));
    return response;
  }

  delete(String uri, data) async {
    var response = await _dio.delete(myIP + uri, data: data, options: Options(
      validateStatus: (status) {
        if (status! >= 200 && status <= 399) {
          return true; // Response is considered valid
        } else {
          throw DioException(
            response: Response(
                statusCode: status, requestOptions: RequestOptions(path: '')),
            error: 'Request failed with status code $status',
            requestOptions: RequestOptions(path: uri),
          );
        }
      },
    ));
    return response;
  }
}
