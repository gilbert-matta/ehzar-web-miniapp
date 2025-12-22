class ContentManagementModel {
  String code;
  String? title;
  String? description;
  String? image;

  ContentManagementModel({
    required this.code,
    required this.title,
    required this.description,
    required this.image,
  });

  factory ContentManagementModel.fromJson(Map<String, dynamic> json) {
    return ContentManagementModel(
      code: json['code'],
      title: json["title"],
      description: json['description'],
      image: json['image'],
    );
  }
}
