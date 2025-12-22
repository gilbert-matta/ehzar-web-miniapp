

import 'package:ahzir/models/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioRepository{

  final DioService dioService = DioService();

  getRepo({required String uri, required data}) async{
    Response response = await dioService.get(uri: uri, data: data);
    return response;
  }

  postUserRepo({required BuildContext context, required String uri, required data}) async{
    Response response = await dioService.post(context: context, uri: uri, data: data);
    return response;
  }

  patchUserRepo({required BuildContext context, required String uri, required data}) async{
    Response response = await dioService.patch(context: context, uri: uri, data: data);
    return response;
  }

  deleteUserRepo({required BuildContext context, required String uri, required data}) async{
    Response response = await dioService.delete(uri: uri, data: data, context: context);
    return response;
  }
}