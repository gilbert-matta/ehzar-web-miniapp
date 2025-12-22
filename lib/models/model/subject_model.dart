

import 'dart:ui';

class SubjectModel{
  String name;
  String? image;
  Color? color;
  bool isChecked;


  SubjectModel({
    required this.name,
    this.image,
    this.color,
    this.isChecked = false,
  });
}