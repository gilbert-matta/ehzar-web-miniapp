class NotificationModel {
  int? id;
  String? title;
  String? body;
  String? date;
  String? slug;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.date,
    this.slug,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      date: json['date'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'slug': slug,
      'date': date,
    };
  }
}
