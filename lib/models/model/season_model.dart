class SeasonModel {
  int id;
  int startingYear;
  int endingYear;

  SeasonModel(
      {required this.id, required this.startingYear, required this.endingYear});

  factory SeasonModel.fromJson(Map<String, dynamic> json){
    return SeasonModel(
        id: json['id'],
        startingYear: json['startingYear'],
        endingYear: json['endingYear']
    );
  }
}
