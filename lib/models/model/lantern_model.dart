

class LanternModel{
  List<StorePackageModel> lanterns;


  LanternModel({
    this.lanterns = const [],
  });

  factory LanternModel.fromJson(Map<String, dynamic> json){
    return LanternModel(
        lanterns: (json as List<dynamic>) // Cast to List<dynamic>
            .map((e) => StorePackageModel.fromJson(e as Map<String, dynamic>)) // Convert each item
            .toList()
    );
  }
}


class StorePackageModel{
  int id;
  String name;
  String? logo;
  int price;
  int storecampaignId;
  bool isForAllChampionships;


  StorePackageModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.price,
    required this.storecampaignId,
    required this.isForAllChampionships,
  });

  factory StorePackageModel.fromJson(Map<String, dynamic> json){
    return StorePackageModel(
        id: json['id'],
        name: json['name'],
        logo: json['logo'],
        price: json['price'],
        storecampaignId: json['storecampaignId'],
        isForAllChampionships: json['isForAllChampionships']
    );
  }
}