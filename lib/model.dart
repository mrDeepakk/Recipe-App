class RecepiModel {
  late String imgUrl;
  late String sourceUrl;
  late double calories;
  late String level;

  RecepiModel(
      {this.imgUrl = "imgurl",
      this.sourceUrl = "source",
      this.level = "level",
      this.calories = 0.00});

  factory RecepiModel.fromMap(Map<String, dynamic> recepi) {
    return RecepiModel(
        imgUrl: recepi['image'],
        sourceUrl: recepi["url"],
        level: recepi['label'],
        calories: recepi['calories']);
  }
}
