import 'package:flutter/services.dart';

import 'recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialog/ok_cancel_dialog.dart';

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
    final recipeDetailStatus = context.read<RecipeDetailStatus>();
    return GestureDetector(
      onTap: () => debugPrint(
          "[ProcessItem] id: ${recipeProcessData.id}, label: ${recipeProcessData.label}, value: ${recipeProcessData.value}"),
      child: Card(
        color: const Color.fromRGBO(212, 207, 207, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: recipeDetailStatus.isEdit,
                  child: const Icon(Icons.drag_handle)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton(
                  value: recipeProcessData.label ?? "Pour",
                  dropdownColor: Colors.white,
                  items: [
                    // TODO: Use Dialog?
                    DropdownMenuItem(
                        value: "Pour",
                        child: Row(
                          children: [
                            const Icon(Icons.water_drop_outlined),
                            const SizedBox(width: 8),
                            const Text("Pour"),
                          ],
                        )),

                    DropdownMenuItem(
                      value: "Wait",
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_top),
                          const SizedBox(width: 8),
                          const Text("Wait"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Stir",
                      child: Row(
                        children: [
                          const Icon(Icons.replay_circle_filled),
                          const SizedBox(width: 8),
                          const Text("Stir"),
                        ],
                      ),
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
                        prefixIcon: const Icon(Icons.onetwothree),
                        suffixText: getSuffixText()),
                  ),
                ),
              ),
              Visibility(
                visible: recipeDetailStatus.isEdit,
                child: IconButton(
                  onPressed: () async {
                    final bool? dialogResult = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return const OkCancelDialog(
                            title: "CoffeeRecipeManager",
                            content: "Want to delete?");
                      },
                    );
                    if (dialogResult != null) {
                      if (dialogResult) {
                        recipeDetailStatus.removeProcess(recipeProcessData);
                      }
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
