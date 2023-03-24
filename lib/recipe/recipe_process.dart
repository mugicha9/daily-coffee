import 'package:flutter/services.dart';

import 'recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeProcessData {
  int id;
  String? label;
  int? value;
  Duration? time;

  RecipeProcessData({required this.id, this.label, this.value, this.time});

  String getString() {
    return "[ProcessData] id: $id, label: $label, value: $value";
  }
}

class ProcessItemField {
  final int id;
  final RecipeProcessData recipeProcessData;
  final TextEditingController controller;

  ProcessItemField(this.id, this.recipeProcessData, this.controller);

  void dispose() {
    controller.dispose();
  }
}

class ProcessItem extends StatelessWidget {
  final TextEditingController textController;
  final RecipeProcessData recipeProcessData;

  const ProcessItem(
      {Key? key, required this.recipeProcessData, required this.textController})
      : super(key: key);

  String getSuffixText() {
    var label = recipeProcessData.label ?? "Pour";
    switch (label) {
      case "Pour":
        return "g";
      case "Wait":
        return "s";
      case "Stir":
        return "Times";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "[ProcessItem Build] id: ${recipeProcessData.id}, label: ${recipeProcessData.label}, value: ${recipeProcessData.value}");
    final recipeDetailStatus = context.read<RecipeDetailStatus>();
    return GestureDetector(
      onTap: () => debugPrint(
          "[ProcessItem] id: ${recipeProcessData.id}, label: ${recipeProcessData.label}, value: ${recipeProcessData.value}"),
      child: Card(
        color: Color.fromRGBO(212, 207, 207, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: recipeDetailStatus.isEdit,
                  child: Icon(Icons.drag_handle)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton(
                  value: recipeProcessData.label ?? "Pour",
                  items: [
                    // TODO: Use Dialog?
                    DropdownMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.water_drop_outlined),
                            SizedBox(width: 8),
                            Text("Pour"),
                          ],
                        ),
                        value: "Pour"),
                    DropdownMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.hourglass_top),
                            SizedBox(width: 8),
                            Text("Wait"),
                          ],
                        ),
                        value: "Wait"),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.replay_circle_filled),
                          SizedBox(width: 8),
                          Text("Stir"),
                        ],
                      ),
                      value: "Stir",
                    )
                  ],
                  onChanged: recipeDetailStatus.isEdit
                      ? ((String? value) {
                          recipeDetailStatus.updateProcess(recipeProcessData.id,
                              value ?? "Pour", null, null);
                          if (value == "Wait") {
                            recipeDetailStatus.updateProcess(
                                recipeProcessData.id,
                                null,
                                textController.text.isEmpty
                                    ? null
                                    : int.parse(textController.text),
                                Duration(
                                    seconds: textController.text.isEmpty
                                        ? 0
                                        : int.parse(textController.text)));
                          }
                        })
                      : null,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: textController,
                    enabled: recipeDetailStatus.isEdit,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (String _value) {
                      var value = _value.isEmpty ? 0 : int.parse(_value);
                      if (recipeProcessData.label != "Wait") {
                        recipeDetailStatus.updateProcess(recipeProcessData.id,
                            recipeProcessData.label ?? "Pour", value, null);
                      } else {
                        recipeDetailStatus.updateProcess(
                            recipeProcessData.id,
                            recipeProcessData.label ?? "Pour",
                            value,
                            Duration(seconds: value));
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.onetwothree),
                        suffixText: getSuffixText()),
                  ),
                ),
              ),
              Visibility(
                visible: recipeDetailStatus.isEdit,
                child: IconButton(
                    onPressed: () {
                      recipeDetailStatus.removeProcess(recipeProcessData);
                    },
                    icon: Icon(Icons.remove),
                    style: IconButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: CircleBorder())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
