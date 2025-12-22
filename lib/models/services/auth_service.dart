


import 'package:ahzir/dio/dio_client.dart';
import 'package:ahzir/dio/dio_exceptions.dart';
import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:ahzir/widgets/loader/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  DioClient dio = DioClient();
  late SharedPreferences prefs;
  // FlutterSecureStorage storage = const FlutterSecureStorage();

  register({required BuildContext context, required String uri, required data}) async{
    Response response;
    try{
      LoaderWidget().show(context);
      response = await dio.post(uri, data);
      LoaderWidget().remove();
      if(response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }else{
        ErrorDialog(context: context, error: response.data['message']);
        final errorResponse = Response(
          statusCode: response.statusCode,
          data: {'message' : DioExceptions.fromDioError(response.data['message']).toString()},
          requestOptions: RequestOptions(path: ''),
        );
        return errorResponse;
      }
    } on DioException catch (e) {
      LoaderWidget().remove();
      ErrorDialog(context: context, error: DioExceptions.fromDioError(e).toString());
      final errorResponse = Response(
        statusCode: e.response?.statusCode,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
      return errorResponse;
    }
  }


  login({required BuildContext context, required String uri, required data}) async{
    Response response;
    try{
      LoaderWidget().show(context);
      response = await dio.post(uri, data);
      LoaderWidget().remove();
    } on DioException catch(e){
      LoaderWidget().remove();
      final errorResponse = Response(
        statusCode: e.response?.statusCode,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
      return errorResponse;
    }
    return response;
  }

  requestOtp({required BuildContext context, required data}) async{
    Response response;
    try{
      response = await dio.post("${BaseUrls.version}${BaseUrls.requestOtp}", data);
      LoaderWidget().remove();
        return response;
    } on DioException catch(e){
      LoaderWidget().remove();
      ErrorDialog(context: context, error: DioExceptions.fromDioError(e).toString());
      final errorResponse = Response(
        statusCode: e.response?.statusCode,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
      return errorResponse;
    }
  }

  verifyOtp({required BuildContext context, required data}) async{
    Response response;
    prefs = await SharedPreferences.getInstance();
    try{
      response = await dio.post("${BaseUrls.version}${BaseUrls.checkOtp}", data);
      if(response.statusCode == 200 || response.statusCode == 201){
        LoaderWidget().remove();
        prefs.setString("token", response.data['token']);
        return response;
      }else{
        LoaderWidget().remove();
        ErrorDialog(context: context, error: response.data['message'] ?? response.statusMessage);
        final errorResponse = Response(
          statusCode: response.statusCode,
          data: {'message' : DioExceptions.fromDioError(response.data['message']).toString()},
          requestOptions: RequestOptions(path: ''),
        );
        return errorResponse;
      }
    } on DioException catch(e){
      LoaderWidget().remove();
      ErrorDialog(context: context, error: DioExceptions.fromDioError(e).toString());
      final errorResponse = Response(
        statusCode: e.response?.statusCode,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
      return errorResponse;
    }
  }
  //
  // resetPass({required BuildContext context, required data}) async{
  //   Response response;
  //   try{
  //     response = await dio.patch(BaseUrls.resetPass, data);
  //     if(response.statusCode == 200 || response.statusCode == 201){
  //       LoaderWidget().remove();
  //       return response.data;
  //     }else{
  //       LoaderWidget().remove();
  //       ErrorDialog(context, response.data['message'] ?? response.statusMessage);
  //       throw response.data['message'] ?? response.statusMessage;
  //     }
  //   } on DioException catch(e){
  //     LoaderWidget().remove();
  //     ErrorDialog(context, DioExceptions.fromDioError(e).toString());
  //     throw DioExceptions.fromDioError(e).toString();
  //   }
  // }
  //
  //
  removeAccount() async{
    Response response;
    try{
      response = await dio.delete("${BaseUrls.version}${BaseUrls.deleteAccount}", null);
      LoaderWidget().remove();
    } on DioException catch(e){
      LoaderWidget().remove();
      final errorResponse = Response(
        statusCode: e.response?.statusCode,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
      return errorResponse;
    }
    return response;
  }
  //
  //
  // getProfile(BuildContext context) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Response response;
  //   try{
  //     response = await dio.get(BaseUrls.userProfile, null);
  //     return response;
  //   } on DioException catch(e){
  //     if(e.response?.statusCode == 401){
  //       prefs.remove("token");
  //       prefs.remove("user");
  //       if(prefs.getBool("initialStepsChecked") == true) {
  //         nextScreenCloseOthers(context, const Login());
  //       }else{
  //         nextScreenCloseOthers(context, const Carousel());
  //       }
  //       return;
  //     }
  //     nextScreenCloseOthers(context, ErrorPage(page: const IntroPage(), errorText: DioExceptions.fromDioError(e).toString()));
  //   }
  // }
  //
  // logOut(BuildContext context) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try{
  //     await dio.post(BaseUrls.logout, null);
  //     prefs.remove('token');
  //   } on DioException catch(e){
  //     prefs.remove('token');
  //     ErrorDialog(context, DioExceptions.fromDioError(e).toString());
  //   }
  // }

  patch({required BuildContext context, required String uri, required data}) async{
    Response response;
    try{
      response = await dio.patch(uri, data);
      LoaderWidget().remove();
      return response;
    } on DioException catch(e){
      LoaderWidget().remove();
      return Response(
        statusCode: e.response?.statusCode,
        data: {'message' :'error'},
        requestOptions: RequestOptions(path: ''),
      );
    }
  }

}