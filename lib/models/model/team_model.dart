class TeamModel {
  int id;
  String? name;
  String? shortName;
  String? imgUrl;

  TeamModel(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.imgUrl,
      });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
      shortName: json['shortName'],
      imgUrl: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'imgUrl': imgUrl,
    };
  }
}
