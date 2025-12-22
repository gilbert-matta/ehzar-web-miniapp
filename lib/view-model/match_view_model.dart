


import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/main.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/repository/match_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MatchViewModel extends ChangeNotifier{
  final MatchRepository matchRepository;

  MatchViewModel({
    required this.matchRepository, //this is how we use the DI we inject its dependencies
  });

  getMatches({int? tournamentId, required int limit, required int page, required String dateFrom, required String dateTo}) async{
    var data = {
      "limit": limit,
      "page": page,
      "dateFrom": dateFrom,
      "dateTo": dateTo,
    };
    if (tournamentId != null) {
      data["championships"] = tournamentId;
    }
    // debugPrint("getMatches data: $data");
    Response res = await matchRepository.getMatches(uri: "${BaseUrls.version}${BaseUrls.match}", data: data);
    return res;
  }

  getMatchesPerTournamentPerMatchWeek({required int tournamentId, required String dateNow, required int limit, required int page, int? matchdaynumber}) async{
    var data = {
      "championshipId": tournamentId,
      "dateNow": dateNow,
      "limit": limit,
      "page": page,
      "matchdaynumber": matchdaynumber,
    };
    // debugPrint("getMatches per week data: $data");
    Response res = await matchRepository.getMatches(uri: "${BaseUrls.version}${BaseUrls.match}${BaseUrls.perTournament}", data: data);

    return res;
  }

  dailyMatches({int? tournamentId, required int limit, required int page}) async{
    var data = {
      "limit": limit,
      "page": page,
    };
    // debugPrint("get daily Matches data: $data");
    Response res = await matchRepository.getMatches(uri: "${BaseUrls.version}${BaseUrls.match}${BaseUrls.dailyChallenge}", data: data);
    return res;
  }

  getMatchPerId({required int id}) async{
    Response res = await MatchRepository().getMatches(uri: "${BaseUrls.version}${BaseUrls.match}/$id", data: null);
    return res;
  }

  setMatchPrediction({required var data}) async{
    Response res = await MatchRepository().setMatchPredictions(uri: "${BaseUrls.version}${BaseUrls.prediction}", data: data);
    return res;
  }

  submitDailyPrediction({required var data}) async{
    Response res = await matchRepository.setMatchPredictions(uri: "${BaseUrls.version}${BaseUrls.dailyPrediction}", data: data);
    return res;
  }

  getLiveMatch() async{
    Response res = await MatchRepository().getMatches(uri: "${BaseUrls.version}${BaseUrls.liveMatch}", data: null);
    return res;
  }

  getFavoriteMatches({required int limit, required int page, String? dateFrom, String? dateTo}) async{
    var data = {
      "limit": limit,
      "page": page,
      "dateFrom": dateFrom,
      "dateTo": dateTo
    };
    // debugPrint("data history: $data");
    Response res = await MatchRepository().getFavMatches(uri: "${BaseUrls.version}${BaseUrls.favoriteMatches}", data: data);
    return res;
  }


  Map<String, dynamic> getMatchesFromResponse(var response) {
    Map<String, dynamic> result = {'data': null, 'error': null};

    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      List<dynamic> dataValue = response.data['data'];
      List<MatchModel> matches =
      dataValue.map((val) => MatchModel.fromJson(val)).toList();
      // debugPrint("upcMatches: $upcomingMatches");
      result['data'] = matches;
    } else {
      // debugPrint("Error: ${response.data}");
      result['error'] = response.data['message'];
    }

    return result;
  }


  Map<String, dynamic> getLiveMatchFromResponse(var response) {
    Map<String, dynamic> result = {'data': null, 'error': null};

    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      var dataValue = response.data;
      if (dataValue is! Map<String, dynamic>) {
        result['data'] = null;
      }else {
        MatchModel matches = MatchModel.fromJson(dataValue);
        // debugPrint("livematches: $upcomingMatches");
        result['data'] = matches;
      }
    } else {
      // debugPrint("Error: ${response.data}");
      result['error'] = response.data['message'];
    }

    return result;
  }


  getUserPredictions({required int limit, required int page}) async{
    var data = {
      "page": page,
      "limit": limit
    };
    // debugPrint("history: limit: $limit -- page: $page");
    Response res = await MatchRepository().getMatches(uri: "${BaseUrls.version}${BaseUrls.predictionsHistory}", data: data);
    return res;
  }

  getVideosPerMatchId({required int matchId, int? page, int? limit}) async{
    var data = {
      "matchId": matchId,
      "page": page,
      "limit": limit,
    };
    // debugPrint("getVideosPerMatchId: limit: $limit -- page: $page -- offset: $offset -- matchid: $matchId");
    Response res = await MatchRepository().getVideosPerMatchId(uri: "${BaseUrls.version}${BaseUrls.vodMobile}", data: data);
    return res;
  }

}