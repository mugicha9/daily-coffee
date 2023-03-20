import 'recipe_process.dart';

class RecipeData {
  int id;
  String title;
  int? water;
  int? temperature;
  int? bean;
  int? timeSecond;
  String? grain;
  RecipeProcessSequence? processSequence;

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
          RecipeProcessSequence? processSequence}) =>
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

  RecipeData copyFrom(RecipeData rd) {
    return RecipeData(
      id: id,
      title: rd.title,
      water: rd.water ?? water,
      temperature: rd.temperature ?? temperature,
      bean: rd.bean ?? bean,
      grain: rd.grain ?? grain,
      timeSecond: rd.timeSecond ?? timeSecond,
    );
  }
}
