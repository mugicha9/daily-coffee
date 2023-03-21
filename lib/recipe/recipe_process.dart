import 'package:flutter/services.dart';

import 'recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeProcessData {
  final int id;
  String? label;
  int? value;

  RecipeProcessData({required this.id, this.label, this.value});
}

//TODO: Improve UI Design
//    : Separete file
class ProcessItem extends StatefulWidget {
  final int id;
  final String? label;
  final int? value;

  const ProcessItem({
    Key? key,
    required this.id,
    required this.label,
    required this.value,
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
    return Card(
      color: Color.fromRGBO(212, 207, 207, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.id.toString()),
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
                                  widget.id, label, null);
                              switch (value) {
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
                            },
                          )
                        })
                    : null,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _textController,
                  enabled: recipeDetailStatus.isEdit,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String _value) {
                    value = _value.isEmpty ? null : int.parse(_value);
                    recipeDetailStatus.updateProcess(widget.id, null, value);
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
    );
  }
}
