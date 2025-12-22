

class MatchDayModel{
  int id;
  int championshipId;
  int seasonId;
  int dayNumber;
  String startingDate;
  String endingDate;


  MatchDayModel({
    required this.id,
    required this.championshipId,
    required this.seasonId,
    required this.dayNumber,
    required this.startingDate,
    required this.endingDate,
  });

  factory MatchDayModel.fromJson(Map<String, dynamic> json){
    return MatchDayModel(
        id: json['id'],
        championshipId: json['championshipId'],
        seasonId: json['seasonId'],
        dayNumber: json['dayNumber'],
        startingDate: json['startingDate'],
        endingDate: json['endingDate']
    );
  }
}