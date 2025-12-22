import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/repository/store_repository.dart';
import 'package:dio/dio.dart';

class StoreViewModel extends ChangeNotifier {

  bool _popUpEnteredInventory = false;
  get getPopupEnteredInventory => _popUpEnteredInventory;
  set setPopupEnteredInventory (bool entered) {
    _popUpEnteredInventory = entered;
    notifyListeners();
  }

  int? _orderId;
  get getOrderId => _orderId;
  set setOrderId (int orderId) {
    _orderId = orderId;
    notifyListeners();
  }

  getStore(
      {required int page,
      required int limit,
      required String? campaignName}) async {
    var data = {
      "page": page,
      "limit": limit,
      "name": campaignName,
    };
    Response res = await StoreRepository()
        .getStore(uri: "v1/${BaseUrls.storePackages}", data: data);
    return res;
    // notifyListeners();
  }

  getUserPurchases({required int page, required int limit}) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    Response res = await StoreRepository().getStore(
        uri: "v1/${BaseUrls.storePackages}/${BaseUrls.purchases}", data: data);
    return res;
  }

  purchaseLanterns(
      {required BuildContext context,
      required List<Map<String, dynamic>> data}) async {
    Response res = await StoreRepository().purchase(
        context: context, uri: "v1/${BaseUrls.storePackages}", data: data);
    return res;
  }

  useLantern(
      {required BuildContext context,
      required Map<String, dynamic> data}) async {
    // debugPrint("useLantern: $data");
    Response res = await StoreRepository().useLanternUser(
        context: context, uri: "v1/${BaseUrls.storePackages}", data: data);
    return res;
  }


  chosenLantern(
      {required BuildContext context,
        required Map<String, dynamic> data}) async {
    // debugPrint("useLantern: $data");
    Response res = await StoreRepository().chosenVoucher(
        context: context, uri: "v1/${BaseUrls.storePackages}/${BaseUrls.updateUserStorePackage}", data: data);
    return res;
  }

  chosenLanternDaily(
      {required BuildContext context,
        required Map<String, dynamic> data}) async {
    // debugPrint("useLantern: $data");
    Response res = await StoreRepository().chosenVoucher(
        context: context, uri: "v1/${BaseUrls.storePackages}/${BaseUrls.updateUserStorePackage}/${BaseUrls.daily}", data: data);
    return res;
  }

  savePredictionsPerWeek(
      {required BuildContext context,
      required int championshipId,
      required String dateNow}) async {
    // debugPrint("useLantern: $championshipId -- $dateNow");
    Response res = await StoreRepository().saveUserPredictions(
        context: context,
        uri:
            "v1/${BaseUrls.prediction}${BaseUrls.submitPredictions}?championshipId=$championshipId&dateNow=$dateNow",
        data: null);
    return res;
  }

  addRedeemCode({required BuildContext context, required int code}) async {
    var data = {"code": code};
    // debugPrint("code: $code");
    Response res = await StoreRepository().setRedeemCode(
        context: context, uri: "v1/${BaseUrls.redeemCode}", data: data);
    return res;
  }

  getChampionshipPackages({required int championshipId, required String type}) async {
    var data = {
      "type": type
    };
    Response res = await StoreRepository().getStore(
        uri:
            "v1/${BaseUrls.storePackages}/${BaseUrls.getChampionshipPackages}/$championshipId",
        data: data);
    return res;
  }


  getUserActivePackage({ required String type, required int championshipId, required int? weekNumber, required int? campaignId }) async {
    var data = {
      "type": type,
      'weekNumber': weekNumber,
      'championshipId': championshipId,
      'campaignId': campaignId,
    };
    Response res = await StoreRepository().getStore(
        uri:
        "v1/${BaseUrls.storePackages}/${BaseUrls.activeStorePackage}",
        data: data);
    return res;
  }

  getDailyUserActivePackage({ required int championshipId, required String dateNow }) async {
    var data = {
      'championshipId': championshipId,
      'dateNow': dateNow,
    };
    Response res = await StoreRepository().getStore(
        uri:
        "v1/${BaseUrls.storePackages}/${BaseUrls.activeStorePackage}/${BaseUrls.daily}",
        data: data);
    return res;
  }


  getPackagesByChampionshipId({required int championshipId}) async {
    Response res = await StoreRepository().getStore(
        uri:
        "v1/${BaseUrls.storePackages}/${BaseUrls.storepackagesByChampionship}/$championshipId",
        data: null);
    return res;
  }

  getDailyChampionshipPackages({required int championshipId}) async {
    Response res = await StoreRepository().getStore(
        uri:
            "v1/${BaseUrls.storePackages}/${BaseUrls.getDailyChampionshipPackages}/$championshipId",
        data: null);
    return res;
  }

  createOrder({ required BuildContext context, required var data }) async {
    Response res = await StoreRepository().createOrder(
      context: context,
        uri:
        "v1/${BaseUrls.order}/${BaseUrls.create}", data: data);
    return res;
  }

  orderStatus() async {
    Response res = await StoreRepository().getOrderStatus(
        uri:
        "v1/${BaseUrls.order}/${BaseUrls.status}/${getOrderId}",
        data: null);
    return res;
  }
}
