class VodModel {
  int id;
  String title;
  String? description;
  String link;
  String image;
  String createdAt;
  String updatedAt;

  VodModel({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VodModel.fromJson(Map<String, dynamic> json) {
    return VodModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        link: json['link'],
        image: json['image'] ?? '',
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
