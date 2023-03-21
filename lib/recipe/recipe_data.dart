import 'recipe_process.dart';

enum RecipeIndex {
  ID,
  Title,
  Water,
  Temperature,
  Been,
  TimeSecond,
  Grain,
  Precess,
}

class RecipeData {
  int id;
  String title;
  int? water;
  int? temperature;
  int? bean;
  int? timeSecond;
  String? grain;
  List<RecipeProcessData>? processSequence;

  RecipeData({
    required this.title,
    required this.id,
    this.water,
    this.temperature,
    this.bean,
    this.grain,
    this.timeSecond,
    this.processSequence,
  });

  setId(int id) {
    this.id = id;
  }

  RecipeData copyWith(
          {String? title,
          int? id,
          int? water,
          int? temperature,
          int? bean,
          String? grain,
          int? timeSecond,
          List<RecipeProcessData>? processSequence}) =>
      RecipeData(
        id: id ?? this.id,
        title: title ?? this.title,
        water: water ?? this.water,
        temperature: temperature ?? this.temperature,
        bean: bean ?? this.bean,
        grain: grain ?? this.grain,
        timeSecond: timeSecond ?? this.timeSecond,
        processSequence: processSequence ?? this.processSequence,
      );

  void updateWith(RecipeIndex recipeIndex) {}
}
