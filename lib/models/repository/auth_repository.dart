import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/services/auth_service.dart';
import 'package:ahzir/models/services/dio_service.dart';
import 'package:ahzir/models/services/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final DioService dioService = DioService();
  final AuthService authService = AuthService();
  final Service service = Service();

  authLogin(
      {required BuildContext context,
      required String uri,
      required data}) async {
    Response response =
        await authService.login(context: context, uri: uri, data: data);
    return response;
  }

  saveProfile(
      {required BuildContext context,
      required String uri,
      required data}) async {
    Response response =
        await dioService.post(context: context, uri: uri, data: data);
    return response;
  }

  refreshToken(
      {required BuildContext context,
      required String uri,
      required data}) async {
    Response response = await service.post(uri: uri, data: data);
    return response;
  }

  authRegister(
      {required BuildContext context,
      required String uri,
      required data}) async {
    return await authService.register(context: context, uri: uri, data: data);
  }

  requestOtpCode({required BuildContext context, required data}) async {
    Response res = await authService.requestOtp(context: context, data: data);
    return res;
  }

  verifyCode({required BuildContext context, required data}) async {
    Response res = await authService.verifyOtp(context: context, data: data);
    return res;
  }

  deleteUser() async {
    return await authService.removeAccount();
  }

  resetPassword({required BuildContext context, required data}) async {
    Response res = await authService.patch(
        context: context,
        uri: "${BaseUrls.version}${BaseUrls.resetPassword}",
        data: data);
    return res;
  }

  contentManagement() async {
    Response res = await dioService.get(
        uri: "${BaseUrls.version}${BaseUrls.contentManagement}", data: null);
    return res;
  }

  // updateFcmToken({required data}) async{
  //   Response res = await dioService.put(uri: "${BaseUrls.version}${BaseUrls.updateFcmToken}", data: data);
  //   return res;
  // }
  createGroup(
      {required BuildContext context,
      required data,
      Map<String, dynamic>? headers}) async {
    Response res = await dioService.post(
        context: context,
        uri: "${BaseUrls.version}${BaseUrls.group}",
        data: data,
        headers: {
          'Content-Type': 'multipart/form-data',
        });
    return res;
  }

  getUserInfo() async {
    Response res = await dioService.get(
        uri: "${BaseUrls.version}${BaseUrls.user}", data: null);
    return res;
  }

  updateUserDetails({required BuildContext context, required Object data}) async {
    Response res = await dioService.patch(
      context: context,
        uri: "${BaseUrls.version}${BaseUrls.userMobile}/${BaseUrls.updateProfile}", data: data);
    return res;
  }
}
