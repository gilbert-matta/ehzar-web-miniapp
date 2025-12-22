

import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/content_management_model.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:easy_localization/easy_localization.dart';

checkIfDataListEmpty({required List data, required Widget widget, EdgeInsetsGeometry? edgeInsets}){
  if(data.isNotEmpty){
    return widget;
  }else{
    return Padding(
      padding: edgeInsets ?? const EdgeInsets.all(0),
      child: Text("No data found!", style: TextStyle(
        fontSize: fontSize14,
        color: whiteColor,
      ),).tr(),
    );
  }
}


void handleResponse<T>({
  required var response,
  required Function(DataLoadState) updateState,
  required Function(String?) updateError,
  required Function(T?) updateData,
}) {
  if (response['error'] != null) {
    updateState(DataLoadState.error);
    updateError(response['error']);
  } else {
    updateState(DataLoadState.loaded);
    updateData(response['data']);
  }
}


void cmsHandle<T>({
  required var response,
  required Function(T?) updateData,
}) {
  if (response['error'] != null) {
    updateData(null);
  } else {
    updateData(response['data']);
  }
}

Map<String, dynamic> getContent(var response) {
  Map<String, dynamic> result = {'data': null, 'error': null};
  if (response.statusCode != null &&
      (response.statusCode! >= 200 && response.statusCode! <= 399)) {
    List<dynamic> dataValue = response.data;
    List<ContentManagementModel> tournaments =
    dataValue.map((val) => ContentManagementModel.fromJson(val)).toList();
    // debugPrint("upcMatches: $upcomingMatches");
    result['data'] = tournaments;
  } else {
    // debugPrint("Error: ${response.data}");
    result['error'] = response.data['message'];
  }

  return result;
}



Map<String, dynamic> getDataLanterns(var response) {
  Map<String, dynamic> result = {'data': null, 'error': null};
  if (response.statusCode != null &&
      (response.statusCode! >= 200 && response.statusCode! <= 399)) {
    List<dynamic> dataValue = response.data['data'];
    List<StoreModel> content =
    dataValue.map((val) => StoreModel.fromJson(val)).toList();
    // debugPrint("upcMatches: $upcomingMatches");
    result['data'] = content;
  } else {
    // debugPrint("Error: ${response.data}");
    result['error'] = response.data['message'];
  }

  return result;
}