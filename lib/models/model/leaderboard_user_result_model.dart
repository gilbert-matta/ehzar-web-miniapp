import 'package:ahzir/models/model/user_model.dart';

class LeaderboardUserResultModel {
  int? id;
  int? userId;
  int? campaignId;
  int? matchesCount;
  int? predictionsCount;
  int? successCount;
  double? successPercentage;
  num? score;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  LeaderboardUserResultModel({
    this.id,
    this.userId,
    this.campaignId,
    this.matchesCount,
    this.predictionsCount,
    this.successCount,
    this.successPercentage,
    required this.score,
    this.createdAt,
    this.updatedAt,
    required this.user,
  });

  factory LeaderboardUserResultModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserResultModel(
      id: json['id'],
      userId: json['userId'],
      campaignId: json['campaignId'],
      matchesCount: json['matchesCount'],
      predictionsCount: json['predictionsCount'],
      successCount: json['successCount'],
      successPercentage: (json['successPercentage'] as num?)?.toDouble(),
      score: json['score'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
