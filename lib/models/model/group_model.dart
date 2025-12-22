

class GroupModel{
  int id;
  String name;
  String? logo;
  String status;

  GroupModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.status
  });

  factory GroupModel.fromJson(Map<String, dynamic> json){
    return GroupModel(
        id: json['id'],
        name: json['name'],
        logo: json['logo'],
        status: json['status']
    );
  }
}