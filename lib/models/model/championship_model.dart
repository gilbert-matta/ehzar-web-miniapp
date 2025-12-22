class ChampionshipModel {
  int id;
  String name;
  String? code;
  String? icon;
  String? tier;

  ChampionshipModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.icon,
      required this.tier});

  factory ChampionshipModel.fromJson(Map<String, dynamic> json) {
    return ChampionshipModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      icon: json['icon'],
      tier: json['tier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'icon': icon,
      'tier': tier,
    };
  }
}
