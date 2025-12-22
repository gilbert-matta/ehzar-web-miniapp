import 'package:ahzir/models/model/campaign_model.dart';
import 'package:ahzir/models/model/championship_model.dart';
import 'package:ahzir/models/model/prediction_model.dart';
import 'package:ahzir/models/model/team_model.dart';
import 'package:ahzir/models/model/type_model.dart';

class MatchModel {
  int id;
  int championshipId;
  var homeTeamId;
  var awayTeamId;
  String status;
  String matchDate;
  String startingAt;
  String? type;
  var homeTeamScore;
  var awayTeamScore;
  String? createdAt;
  String? updatedAt;
  ChampionshipModel? championship;
  TeamModel? homeTeam;
  TeamModel? awayTeam;
  List<TypeModel> predictionType;
  List<PredictionModel> predictionValues;
  CampaignModel? campaign;

  MatchModel({
    required this.id,
    required this.championshipId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.status,
    required this.matchDate,
    required this.startingAt,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.createdAt,
    required this.updatedAt,
    required this.homeTeam,
    required this.awayTeam,
    this.type, //this is the type if tournament/match...
    this.predictionType = const [], //this is for prediction type if its a MatchResult
    this.predictionValues = const [],
    this.championship,
    this.campaign,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
        id: json['id'],
        championshipId: json['championshipId'],
        homeTeamId: json['homeTeamId'],
        awayTeamId: json['awayTeamId'],
        status: json['status'],
        matchDate: json['matchDate'],
        startingAt: json['startingAt'],
        homeTeamScore: json['homeTeamScore'].toString(),
        awayTeamScore: json['awayTeamScore'].toString(),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        type: json['type'],
        predictionType: json['matchday'] != null && json['matchday']?['predictionType'] != null
            ? (json['matchday']?['predictionType'] as List<dynamic>)
                .map((type) => TypeModel.fromJson(type))
                .toList()
            : [],
        predictionValues: json['userPrediction'] != null
            ? (json['userPrediction'] as List<dynamic>)
                .map((predictions) => PredictionModel.fromJson(predictions))
                .toList()
            : [],
        championship: json['championship'] != null
            ? ChampionshipModel.fromJson(json['championship'])
            : null,
        homeTeam: json['homeTeam'] != null
            ? TeamModel.fromJson(json['homeTeam'])
            : null,
        awayTeam: json['awayTeam'] != null
            ? TeamModel.fromJson(json['awayTeam'])
            : null,
        campaign: json['campaign'] != null
            ? CampaignModel.fromJson(json['campaign']
                as Map<String, dynamic>) // Parse into CampaignModel
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'championshipId': championshipId,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'status': status,
      'matchDate': matchDate,
      'startingAt': startingAt,
      'homeTeamScore': homeTeamScore,
      'awayTeamScore': awayTeamScore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'type': type,
      'predictionType': predictionType,
      'predictionValues': predictionValues,
      'championship': championship?.toJson(),
      'homeTeam': homeTeam?.toJson(),
      'awayTeam': awayTeam?.toJson(),
    };
  }
}
