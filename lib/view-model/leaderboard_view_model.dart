


import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/repository/match_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LeaderboardViewModel extends ChangeNotifier{

  getLeaderboardPerTournament({required int id}) async{ //we get the leaderboard per tournament and we display the first one, bcz we may have many campaigns for this tournament, so we display the first campaign result.
    Response res = await MatchRepository().getMatches(uri: "${BaseUrls.version}${BaseUrls.leaderboard}?tournamentId=$id", data: null);
    return res;
  }

  getLeaderboardByType({required Map data}) async{ //we get the leaderboard per tournament and we display the first one, bcz we may have many campaigns for this tournament, so we display the first campaign result.
    // debugPrint("leaderrrr: $data");
    Response res = await MatchRepository().getLeaderboard(uri: "${BaseUrls.version}${BaseUrls.leaderboard}${BaseUrls.types}", data: data);
    return res;
  }

  getLiveLeaderboard({required Map data}) async{ //we get the leaderboard per tournament and we display the first one, bcz we may have many campaigns for this tournament, so we display the first campaign result.
    // debugPrint("leaderrrr: $data");
    Response res = await MatchRepository().getLeaderboard(uri: "${BaseUrls.version}${BaseUrls.liveLeaderboard}", data: data);
    return res;
  }

  getTypesLeaderboard() async{
    Response res = await MatchRepository().getMatches(uri: "${BaseUrls.version}${BaseUrls.configuration}", data: null);
    return res;
  }

}