import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/repository/auth_repository.dart';
import 'package:ahzir/widgets/loader/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends ChangeNotifier {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  login(BuildContext context, phone, password) async {
    var data = {
      "phone": phone,
      "password": password,
      // 'fcmToken': await storage.read(key: 'fcmtoken')
    };
    // debugPrint("dataaaaa: $data");
    var res = await AuthRepository().authLogin(
        context: context,
        uri: "${BaseUrls.version}${BaseUrls.login}",
        data: data);
    return res;
  }

  refreshToken({required BuildContext context}) async {
    Response res = await AuthRepository().refreshToken(
        context: context,
        uri: "${BaseUrls.version}${BaseUrls.refreshToken}",
        data: null);
    return res;
  }

  registration(BuildContext context, var data) async {
    Response res = await AuthRepository().authRegister(
        context: context, uri: "v1/${BaseUrls.register}", data: data);
    return res;
  }

  requestOtp(context, phone) async {
    var data = {"phone": phone};
    LoaderWidget().show(context);
    Response res =
        await AuthRepository().requestOtpCode(context: context, data: data);
    LoaderWidget().remove();
    notifyListeners();
    return res;
  }

  verifyCode(context, phone, code) async {
    var data = {
      "phone": phone,
      "otp": int.parse(code),
    };
    LoaderWidget().show(context);
    Response res =
        await AuthRepository().verifyCode(context: context, data: data);
    LoaderWidget().remove();
    notifyListeners();
    return res;
  }

  deleteAccount({required BuildContext context}) async {
    LoaderWidget().show(context);
    return await AuthRepository().deleteUser();
  }

  resetPassword(context, data) async {
    LoaderWidget().show(context);
    Response response =
        await AuthRepository().resetPassword(context: context, data: data);
    LoaderWidget().remove();
    notifyListeners();
    return response;
  }

  getContentManagement() async {
    Response response = await AuthRepository().contentManagement();
    notifyListeners();
    return response;
  }

  // updateFcmToken() async{
  //   var data = {
  //     "fcmToken": await storage.read(key: "fcmtoken")
  //   };
  //   Response response = await AuthRepository().updateFcmToken(data: data);
  //   notifyListeners();
  //   return response;
  // }

  createGroup({required BuildContext context, required data}) async {
    Response response =
        await AuthRepository().createGroup(context: context, data: data);
    notifyListeners();
    return response;
  }

  getUser() async {
    Response res = await AuthRepository().getUserInfo();
    return res;
  }

  updateUserDetails({required BuildContext context, required Object data}) async{
    Response res = await AuthRepository().updateUserDetails(context: context, data: data);
    return res;
  }
}
