import 'package:ahzir/models/model/store_model.dart';

class PurchaseModel {
  int userChosenQuantity; //this is for the quantity the user chose for this item
  StoreModel storePackage;

  PurchaseModel({
    required this.userChosenQuantity,
    required this.storePackage,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json){
    return PurchaseModel(
      userChosenQuantity: json['count'],
      storePackage: StoreModel.fromJson(json['storepackage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userChosenQuantity': userChosenQuantity,
      'storePackage': storePackage,
    };
  }
}
