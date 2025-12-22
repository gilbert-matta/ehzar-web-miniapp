import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/tournament_model.dart';

class TournamentResponseModel {
  final TournamentModel? tournamentModel;
  final MatchModel? matchModel;

  TournamentResponseModel({
    this.tournamentModel,
    this.matchModel,
  });

  factory TournamentResponseModel.fromJson(Map<String, dynamic> json) {
    if(json['type'].toString().toLowerCase() == 'match'){
      return TournamentResponseModel(
        matchModel: MatchModel.fromJson(json)
      );
    }else if(json['type'].toString().toLowerCase() == 'championship'){
      return TournamentResponseModel(
        tournamentModel: TournamentModel.fromJson(json)
      );
    }else{
      return TournamentResponseModel(
        tournamentModel: TournamentModel.fromJson(json)
      );
    }
  }
}
