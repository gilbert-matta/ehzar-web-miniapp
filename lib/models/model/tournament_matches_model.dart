

import 'package:ahzir/models/model/campaign_model.dart';
import 'package:ahzir/models/model/match_model.dart';

class TournamentMatchesModel{
  List<MatchModel> matches;
  int userPredictionCount;
  List<UserMatchPredictions> userPredictions;
  CampaignModel? campaign;
  int total;

  TournamentMatchesModel({
    required this.matches,
    required this.userPredictionCount,
    required this.userPredictions,
    required this.campaign,
    required this.total,
  });

  factory TournamentMatchesModel.fromJson(Map<String, dynamic> json){
    return TournamentMatchesModel(
        matches: (json['data'] as List<dynamic>)
            .map((predictions) => MatchModel.fromJson(predictions)).toList(),
        userPredictionCount: json['userPredictionCount'] ?? 0,
        userPredictions: (json['userPredictions'] as List<dynamic>)
            .map((predictions) => UserMatchPredictions.fromJson(predictions)).toList(),
        campaign: CampaignModel.fromJson(json['campaign']),
        total: json['total'] ?? 0,
    );
  }
}


class UserMatchPredictions{
  int id;
  bool predictionscounted;

  UserMatchPredictions({
    required this.id,
    required this.predictionscounted,
  });

  factory UserMatchPredictions.fromJson(Map<String, dynamic> json){
    // print(":jsonnnnnnnnnn: ${json} -- ${json['predictionscounted']}");
    return UserMatchPredictions(
      id: json['id'],
      predictionscounted: json['predictionscounted'],
    );
  }
}