import 'package:ahzir/models/model/prize_model.dart';

class CampaignModel {
  int id;
  String campaignName;
  String startingDate;
  String endingDate;
  PrizeModel? prize;
  int? weekNumber;

  CampaignModel(
      {required this.id,
        required this.campaignName,
        required this.startingDate,
        required this.endingDate,
        required this.prize,
        required this.weekNumber,
      });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'],
      campaignName: json['name'],
      startingDate: json['startingDate'],
      endingDate: json['endingDate'],
      prize: json['prize'] != null
          ? PrizeModel.fromJson(json['prize'] as Map<String, dynamic>) // Parse prize into PrizeModel
          : null, // Handle null case for prize
      weekNumber: json['weekNumber']
    );
  }

}
