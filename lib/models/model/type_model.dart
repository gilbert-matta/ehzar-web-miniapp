import 'package:ahzir/models/model/campaign_model.dart';
import 'package:ahzir/models/model/championship_model.dart';
import 'package:ahzir/models/model/team_model.dart';

class TypeModel {
  int id;
  String name;
  List fields;  //this is the key that i should send a result to it
  String? inputType; // check what is the input to show in ui

  TypeModel({
    required this.id,
    required this.name,
    required this.fields,
    required this.inputType,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
        id: json['id'],
        name: json['name'],
        fields: json['fields'] ?? [],
        inputType: json['inputType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fields': fields,
      'inputType': inputType
    };
  }
}
