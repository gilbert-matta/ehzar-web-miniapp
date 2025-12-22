

import 'package:ahzir/index.dart';
import 'package:ahzir/models/services/dio_service.dart';
import 'package:ahzir/models/services/service.dart';
import 'package:dio/dio.dart';

class StoreRepository{
  Service _service = Service();
  DioService _dioService = DioService();

  getStore({required String uri, required data}) async{
    Response response =  await _service.get(uri: uri, data: data);
    return response;
  }

  getOrderStatus({required String uri, required data}) async{
    Response response =  await _service.get(uri: uri, data: data);
    return response;
  }

  getUserStorePurchases({required String uri, required data}) async{
    Response response =  await _service.get(uri: uri, data: data);
    return response;
  }

  purchase({required BuildContext context, required String uri, required data}) async{
    Response response =  await _dioService.post(context: context, uri: uri, data: data);
    return response;
  }

  useLanternUser({required BuildContext context, required String uri, required data}) async{
    Response response =  await _dioService.patch(context: context, uri: uri, data: data);
    return response;
  }

  chosenVoucher({required BuildContext context, required String uri, required data}) async{
    Response response =  await _dioService.patch(context: context, uri: uri, data: data);
    return response;
  }

  saveUserPredictions({required BuildContext context, required String uri, required data}) async{
    Response response =  await _dioService.patch(context: context, uri: uri, data: data);
    return response;
  }

  setRedeemCode({required BuildContext context, required String uri, required data}) async{
    Response response =  await _dioService.post(context: context, uri: uri, data: data);
    return response;
  }

  createOrder({required BuildContext context, required String uri, required data}) async{
    Response response =  await _dioService.post(context: context, uri: uri, data: data);
    return response;
  }


}