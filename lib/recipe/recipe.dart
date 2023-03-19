class RecipeData {
  final String title;
  int water;
  int temperature;
  int bean;
  int timeSecond;
  String grain;

  RecipeData(
      {required this.title,
      this.water = -1,
      this.temperature = -1,
      this.bean = -1,
      this.grain = "",
      this.timeSecond = -1});

  setWater(int w) {
    water = w;
  }

  setBean(int b) {
    bean = b;
  }

  setTimeSecond(int ts) {
    timeSecond = ts;
  }
}
