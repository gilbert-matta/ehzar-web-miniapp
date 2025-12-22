

import 'package:ahzir/dio/dio_client.dart';
import 'package:ahzir/dio/dio_exceptions.dart';
import 'package:dio/dio.dart';


class ChatService{
  DioClient dio = DioClient();

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

}