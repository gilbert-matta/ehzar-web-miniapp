// import 'dart:ffi';

class ArticleModel {
  int? id;
  String title;
  String? summary;
  String? mediaCover;
  String? description;
  bool? isActive;
  String? publishDate;
  String articleDate;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  ArticleModel(
      {required this.id,
      required this.title,
      required this.summary,
      required this.mediaCover,
      required this.description,
      required this.publishDate,
      required this.articleDate,
      required this.categoryId,
      required this.createdAt,
      required this.updatedAt});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
        id: json['id'],
        title: json['title'],
        summary: json['summary'],
        mediaCover: json['cover'],
        description: json['description'],
        publishDate: json['publishDate'],
        articleDate: json['articleDate'],
        categoryId: json['categoryId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
