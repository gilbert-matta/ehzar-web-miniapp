


import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/repository/team_repository.dart';
import 'package:ahzir/widgets/loader/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TeamViewModel extends ChangeNotifier{

  getTeamsPerLeagueId({required int id}) async{
    // debugPrint("leagueId: $id");
    Response res = await TeamRepository().teamPerLeagueId(uri: "${BaseUrls.version}${BaseUrls.team}?championship=$id", data: null);
    return res;
  }

  setUserFavoriteTeams({required BuildContext context, required List favTeamsList}) async{
    var data = {
      "teamsIds": favTeamsList
    };
    LoaderWidget().show(context);
    Response res = await TeamRepository().saveUserFavTeams(uri: "${BaseUrls.version}${BaseUrls.favorite}", data: data);
    LoaderWidget().remove();
    return res;
  }

  getUserFavoriteTeams({required BuildContext context, required List favTeamsList}) async{
    Response res = await TeamRepository().getUserFavTeams(uri: "${BaseUrls.version}${BaseUrls.favorite}", data: null);
    return res;
  }

}