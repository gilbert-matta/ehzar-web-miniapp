


import 'dart:async';
import 'dart:convert';

import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/pages/match/match_prediction.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

checkUserIfLoggedIn() async{
  prefs = await SharedPreferences.getInstance();
  var checkToken = await prefs.getString('token');
  if(checkToken == null){
    return false;
  }else{
    return true;
  }
}


navigateToMatchPrediction({required BuildContext context, required MatchModel matchInfo, required int matchId, void Function()? onComplete}) async {
  // bool isLoggedIn = await checkUserIfLoggedIn();
  // if(isLoggedIn) {
    nextScreen(context, MatchPrediction(
        matchInfo: matchInfo, matchId: matchId), onComplete: onComplete);
  // }else{
  //   ErrorDialog(context: context, title: 'UnAuthorized', error: 'You are not logged in!');
  // }
}


enum PredictionType{
  result,
  home,
  away,
}

getUserDetails() async {
  prefs = await SharedPreferences.getInstance();
  String? userStorage = prefs.getString('userInfo');
  if (userStorage != null) {
    // debugPrint("userinfooo: $userStorage");
    final decodedData = jsonDecode(userStorage) as Map<String, dynamic>;
    UserModel user = UserModel.fromJson(decodedData);
    return user;
  }
  return null;
}