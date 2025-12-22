

import 'package:ahzir/dio/dio_client.dart';
import 'package:ahzir/dio/dio_exceptions.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:dio/dio.dart';

class Service{
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

  post({required String uri, required data}) async{
    Response response;
    try{
      response = await dio.post(uri, data);
    } on DioException catch(e){
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
      response = await dio.patch(uri, data);
      return response;
    } on DioException catch(e){
      ErrorDialog(context: context, error: DioExceptions.fromDioError(e).toString());
      return Response(
        statusCode: e.response?.statusCode,
        data: {'message' :'error'},
        requestOptions: RequestOptions(path: ''),
      );
    }
  }

  put({required String uri, required data}) async {
    Response response;
    try{
      response = await dio.put(uri, data);
      return response;
    } on DioException catch(e){
      return Response(
        statusCode: e.response?.statusCode,
        data: {'message' :'error'},
        requestOptions: RequestOptions(path: ''),
      );
    }
  }
}