import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    // print("dioerrorrr: ${dioError.type} - ${dioError.error} - ${dioError.response}");
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Internet connection Error"
            .tr(); //"Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Internet connection Error".tr();
        break;
      case DioExceptionType.unknown:
        message = dioError.response == null ? 'An Error Occurred!' : _handleError(
            dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioExceptionType.receiveTimeout:
        message = "Internet connection Error"
            .tr(); //"Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
            dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioExceptionType.sendTimeout:
        message = "Internet connection Error"
            .tr(); //"Send timeout in connection with API server";
        break;
      case DioExceptionType.connectionError:
        message = "Internet connection Error"
            .tr(); //"Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong".tr();
        break;
    }
  }

  late String message;

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return error["message"].toString();
      case 401:
        return 'UnAuthorized';
      case 404:
        return "Not found";
      case 500:
        return 'Internal server error'.tr();
      case null:
      return 'Unknown';
      default:
        return error["message"].toString();
    }
  }

  @override
  String toString() => message;
}
