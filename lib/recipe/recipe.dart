class RecipeData {
  int id;
  String title;
  int? water;
  int? temperature;
  int? bean;
  int? timeSecond;
  String? grain;

  RecipeData(
      {required this.title,
      required this.id,
      this.water,
      this.temperature,
      this.bean,
      this.grain,
      this.timeSecond});

  setId(int id) {
    this.id = id;
  }

  setWater(int w) {
    water = w;
  }

  setBean(int b) {
    bean = b;
  }

  setTimeSecond(int ts) {
    timeSecond = ts;
  }

  RecipeData copyWith(
          {String? title,
          int? id,
          int? water,
          int? temperature,
          int? bean,
          String? grain,
          int? timeSecond}) =>
      RecipeData(
        id: id ?? this.id,
        title: title ?? this.title,
        water: water ?? this.water,
        temperature: temperature ?? this.temperature,
        bean: bean ?? this.bean,
        grain: grain ?? this.grain,
        timeSecond: timeSecond ?? this.timeSecond,
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
