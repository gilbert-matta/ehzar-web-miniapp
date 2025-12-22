import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/models/repository/championship_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChampionshipViewModel extends ChangeNotifier {
  getTournaments({required int limit, required int page}) async {
    var data = {
      "limit": limit,
      "page": page,
    };
    Response res = await ChampionshipRepository().getTournaments(
        uri: "${BaseUrls.version}${BaseUrls.championship}", data: data);
    return res;
  }

  search({required int limit, required int page, required String? q}) async {
    var data = {
      "name": q,
      "limit": limit,
      "page": page,
    };
    // debugPrint("search data: $data");
    Response res = await ChampionshipRepository().getTournaments(
        uri: "${BaseUrls.version}${BaseUrls.championship}${BaseUrls.search}",
        data: data);
    return res;
  }

  Map<String, dynamic> getTournamentsFromResponse(var response) {
    Map<String, dynamic> result = {'data': null, 'error': null};
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      List<dynamic> dataValue = response.data['data'];
      List<TournamentModel> tournaments =
          dataValue.map((val) => TournamentModel.fromJson(val)).toList();
      // debugPrint("upcMatches: $upcomingMatches");
      result['data'] = tournaments;
    } else {
      // debugPrint("Error: ${response.data}");
      result['error'] = response.data['message'];
    }

    return result;
  }

  getMatchDaysByTournamentId(
      {required int limit,
      required int page,
      required int championshipId}) async {
    var data = {
      "limit": limit,
      "page": page,
      "championshipId": championshipId,
    };
    debugPrint("matchdays: $data");
    Response res = await ChampionshipRepository().getTournaments(
        uri: "${BaseUrls.version}${BaseUrls.matchDayMobile}", data: data);
    return res;
  }
}
