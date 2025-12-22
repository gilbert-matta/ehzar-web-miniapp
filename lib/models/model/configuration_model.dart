class ConfigurationModel {
  int id;
  String title;
  String values;

  ConfigurationModel({
    required this.id,
    required this.title,
    required this.values,
  });

  factory ConfigurationModel.fromJson(Map<String, dynamic> json){
    return ConfigurationModel(
        id: json['id'],
        title: json['title'],
        values: json['values']
    );
  }
}