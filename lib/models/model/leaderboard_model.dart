import 'package:ahzir/models/model/campaign_model.dart';
import 'package:ahzir/models/model/championship_model.dart';
import 'package:ahzir/models/model/leaderboard_user_result_model.dart';

class LeaderBoardModel {
  CampaignModel? campaign;
  ChampionshipModel? championship;
  List<LeaderboardUserResultModel>? leaderboardResults;

  LeaderBoardModel({
    required this.campaign,
    required this.championship,
    required this.leaderboardResults,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    return LeaderBoardModel(
      campaign: json['campaign'] != null
          ? CampaignModel.fromJson(json['campaign'] as Map<String, dynamic>)
          : null,
      championship: json['campaign']['championship'] != null
          ? ChampionshipModel.fromJson(json['campaign']['championship'] as Map<String, dynamic>)
          : null,
      leaderboardResults: (json['leaderboard'] as List<dynamic>?)
          ?.map((leaderboardItem) =>
          LeaderboardUserResultModel.fromJson(leaderboardItem['leaderboard'] as Map<String, dynamic>))
          .toList(),
    );
  }
}
