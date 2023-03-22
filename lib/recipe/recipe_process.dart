import 'package:flutter/services.dart';

import 'recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeProcessData {
  final int id;
  String? label;
  int? value;
  Duration? time;

  RecipeProcessData({required this.id, this.label, this.value, this.time});
}

//TODO: Improve UI Design

class ProcessItem extends StatefulWidget {
  final int id;
  final String? label;
  final int? value;
  final Duration? time;

  const ProcessItem({
    Key? key,
    required this.id,
    required this.label,
    required this.value,
    required this.time,
  }) : super(key: key);

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {
  final TextEditingController _textController = TextEditingController();

  late String showText;
  late String suffixText;

  String? label;
  int? value;

  @override
  void initState() {
    super.initState();
    label = widget.label;
    value = widget.value;

    if (value != null) _textController.text = value.toString();

    showText = label ?? "Pour";

    switch (showText) {
      case "Pour":
        suffixText = "g";
        break;
      case "Wait":
        suffixText = "s";
        break;
      case "Stir":
        suffixText = "Times";
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var recipeDetailStatus = context.watch<RecipeDetailStatus>();
    return GestureDetector(
      onTap: () => debugPrint(
          "[ProcessItem] label: $label, showText: $showText, value: $value"),
      child: Card(
        color: Color.fromRGBO(212, 207, 207, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton(
                  value: showText,
                  items: [
                    // TODO: Use Dialog
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
                      ? ((String? value) => {
                            setState(
                              () {
                                showText = value ?? "NULL";
                                label = value;
                                recipeDetailStatus.updateProcess(
                                    widget.id, showText, null, null);
                                switch (value) {
                                  case "Pour":
                                    suffixText = "g";
                                    break;
                                  case "Wait":
                                    suffixText = "s";
                                    recipeDetailStatus.updateProcess(
                                        widget.id,
                                        null,
                                        null,
                                        Duration(seconds: this.value ?? 0));
                                    break;
                                  case "Stir":
                                    suffixText = "Times";
                                    break;
                                  default:
                                }
                              },
                            )
                          })
                      : null,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _textController,
                    enabled: recipeDetailStatus.isEdit,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (String _value) {
                      value = _value.isEmpty ? 0 : int.parse(_value);
                      if (showText != "Wait") {
                        recipeDetailStatus.updateProcess(
                            widget.id, showText, value, null);
                      } else {
                        recipeDetailStatus.updateProcess(widget.id, showText,
                            value, Duration(seconds: value ?? 0));
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.onetwothree),
                        suffixText: suffixText),
                  ),
                ),
              ),
              Visibility(
                visible: recipeDetailStatus.isEdit,
                child: IconButton(
                    onPressed: () {
                      recipeDetailStatus.removeProcess(widget.id);
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
