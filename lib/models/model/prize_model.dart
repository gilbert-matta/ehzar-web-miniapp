

class PrizeModel{
  int? id;
  String? prizeName;
  String? icon;

  PrizeModel({
    required this.id,
    required this.prizeName,
    required this.icon,
  });

  factory PrizeModel.fromJson(Map<String, dynamic> json){
    return PrizeModel(
        id: json['id'],
        prizeName: json['name'],
        icon: json['icon']
    );
  }
}