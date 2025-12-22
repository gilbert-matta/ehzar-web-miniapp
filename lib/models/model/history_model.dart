import 'package:ahzir/models/model/match_model.dart';

class HistoryModel {
  var result;
  var awayScore;
  var homeScore;
  var typesResult;
  MatchModel match;
  String matchType;
  List fields = const [];

  HistoryModel({
    required this.result,
    required this.typesResult,
    required this.awayScore,
    required this.homeScore,
    required this.match,
    required this.matchType,
    required this.fields,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
        result: json['predictionValue']['result'],
        typesResult: json['predictionValue'],
        awayScore: json['predictionValue']['home'],
        homeScore: json['predictionValue']['away'],
        match: MatchModel.fromJson(json['match']),
        matchType: json['type']['name'],
        fields: json['type']['fields']
    );
  }
}
