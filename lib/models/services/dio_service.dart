

import 'package:ahzir/dio/dio_client.dart';
import 'package:ahzir/dio/dio_exceptions.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:ahzir/widgets/loader/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioService{
  DioClient dio = DioClient();

  get({required String uri, required data}) async{
    Response response;
    try{
      response = await dio.get(uri, data);
    } on DioException catch(e){
      return Response(
        statusCode: e.response?.statusCode ?? 520,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
    }
    return response;
  }

  post({required BuildContext context, required String uri, required data, Map<String, dynamic>? headers}) async{
    Response response;
    try{
      LoaderWidget().show(context);
      response = await dio.post(uri, data, headers);
      LoaderWidget().remove();
    } on DioException catch(e){
      LoaderWidget().remove();
      return Response(
        statusCode: e.response?.statusCode ?? 520,
        data: {'message' : DioExceptions.fromDioError(e).toString()},
        requestOptions: RequestOptions(path: ''),
      );
    }
    return response;
  }

  patch({required BuildContext context, required String uri, required data}) async{
    Response response;
    try{
      LoaderWidget().show(context);
      response = await dio.patch(uri, data);
      LoaderWidget().remove();
      return response;
    } on DioException catch(e){
      LoaderWidget().remove();
      ErrorDialog(context: context, error: DioExceptions.fromDioError(e).toString());
      return Response(
        statusCode: e.response?.statusCode,
        data: {'message' :'error'},
        requestOptions: RequestOptions(path: ''),
      );
    }
  }

  delete({required BuildContext context, required String uri, required data}) async{
    Response response;
    try{
      response = await dio.delete(uri, data);
    } on DioException catch(e){
      throw e.toString();
    }
    return response;
  }

  put({required String uri, required data}) async{
    Response response;
    try{
      response = await dio.put(uri, data);
    } on DioException catch(e){
      return Response(
        statusCode: e.response?.statusCode,
        data: {'message' :'error'},
        requestOptions: RequestOptions(path: ''),
      );
    }
    return response;
  }

}