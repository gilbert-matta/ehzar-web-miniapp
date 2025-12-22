import 'package:ahzir/models/model/prize_storepackage.dart';

class StoreModel {
  int id;
  String name;
  String? description;
  String? logo;
  int price;
  String? currency;
  int quantity;
  List<Prize>? prizes;
  // int percentageMarginError;

  StoreModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.price,
    required this.currency,
    this.prizes,
    // required this.percentageMarginError,
    this.quantity = 0,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      price: json['price'] ?? 0,
      // percentageMarginError: json['percentageMarginError'],
      currency: json['currency'],
      quantity: json['quantity'] ?? 0,
      prizes: json['prizes'] != null
          ? (json['prizes'] as List)
              .map((prize) => Prize.fromJson(prize))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'price': price,
      // "percentageMarginError": percentageMarginError,
      'currency': currency,
      'quantity': quantity,
      'prizes': prizes?.map((prize) => prize.toJson()).toList(),
    };
  }
}

class StoreInventoryModel {
  final int storePackageId;
  final int
      quantityUsed; //hay lquantity taba3 l user yale hue 3m yna2ya la ysta3mela mn l inventory, ex: 3nde in this lantern quantity: 2, i used 1 -> this 1 hye l quantityUsed

  StoreInventoryModel({
    required this.storePackageId,
    this.quantityUsed = 0,
  });
}
