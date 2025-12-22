import 'package:ahzir/models/model/campaign_model.dart';
import 'package:ahzir/models/model/championship_model.dart';
import 'package:ahzir/models/model/team_model.dart';

class PredictionModel {
  int id;
  int matchId;
  int typeId;
  Map predictionValue;

  PredictionModel(
      {required this.id,
        required this.matchId,
        required this.typeId,
        required this.predictionValue,
      });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'],
      matchId: json['matchId'],
      typeId: json['typeId'],
      predictionValue: json['predictionValue']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'typeId': typeId,
      'predictionValue': predictionValue
    };
  }
}
