class Prize {
  int id;
  String name;
  String icon;
  int? weekNumber;

  Prize({
    required this.id,
    required this.name,
    required this.icon,
    this.weekNumber,
  });

  factory Prize.fromJson(Map<String, dynamic> json) {
    return Prize(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      weekNumber: json['weekNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'weekNumber': weekNumber,
    };
  }
}
