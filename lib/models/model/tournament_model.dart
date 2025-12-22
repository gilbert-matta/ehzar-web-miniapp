import 'package:ahzir/models/model/season_model.dart';

class TournamentModel {
  int id;
  String name;
  String icon;
  String? type;
  List<SeasonModel> seasons;

  TournamentModel(
      {required this.id,
      required this.name,
      required this.icon,
      required this.seasons,
        this.type,
      });

  factory TournamentModel.fromJson(Map<String, dynamic> json){
    return TournamentModel(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        type: json['type'],
        seasons: (json['seasons'] as List<dynamic>) // Cast to List<dynamic>
            .map((e) => SeasonModel.fromJson(e as Map<String, dynamic>)) // Convert each item
            .toList(), // Convert to List<SeasonModel>
    );
  }
}
