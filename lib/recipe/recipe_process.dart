class RecipeProcessSequence {
  var processData = <RecipeProcessData>[];

  void addProcessData(RecipeProcessData rpd) {
    processData.add(rpd);
  }
}

class RecipeProcessData {
  final int id;
  String? label;
  int? value;

  RecipeProcessData({required this.id, this.label, this.value});
}
