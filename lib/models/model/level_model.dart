class LevelModel {
  int id;
  String name;
  int minPoints;
  int maxPoints;
  String logo;
  var userTotalPoints;
  List<LevelTypeModel> allLevels;

  LevelModel({
    required this.id,
    required this.name,
    required this.minPoints,
    required this.maxPoints,
    required this.logo,
    required this.userTotalPoints,
    required this.allLevels,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['userLevel']['id'],
      name: json['userLevel']['name'],
      minPoints: json['userLevel']['minpoints'],
      maxPoints: json['userLevel']['maxpoints'],
      logo: json['userLevel']['badge'] ?? '',
      userTotalPoints: json['user']['totalpoints'],
      allLevels: (json['allLevels'] != null && json['allLevels'] is List)
          ? (json['allLevels'] as List)
          .map((level) => LevelTypeModel.fromJson(level))
          .toList()
          : []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userLevel": {
        "id": id,
        'name': name,
        'minpoints': minPoints,
        'maxpoints': maxPoints,
        'logo': logo ?? '',
      },
      'user': {
        'totalpoints': userTotalPoints,
      },
    };
  }
}


class LevelTypeModel {
  int id;
  String name;
  int minPoints;
  int maxPoints;
  String logo;
  var successpoints;

  LevelTypeModel({
    required this.id,
    required this.name,
    required this.minPoints,
    required this.maxPoints,
    required this.logo,
    required this.successpoints,
  });

  factory LevelTypeModel.fromJson(Map<String, dynamic> json) {
    // print("ppppppppppp: $json");
    return LevelTypeModel(
        id: json['id'],
        name: json['name'],
        minPoints: json['minpoints'],
        maxPoints: json['maxpoints'],
        successpoints: json['successpoints'],
        logo: json['badge'] ?? '',
    );
  }
}