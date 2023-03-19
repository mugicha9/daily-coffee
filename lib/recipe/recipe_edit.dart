import 'package:daily_coffee/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'recipe.dart';

class RecipeEditPage extends StatefulWidget {
  final RecipeData recipeData;
  final bool isNew;
  const RecipeEditPage(
      {Key? key, required this.recipeData, required this.isNew})
      : super(key: key);

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  // TODO: 1. Make this.

  late RecipeData recipeData;
  late bool isNew;

  @override
  void initState() {
    super.initState();

    recipeData = widget.recipeData;
    isNew = widget.isNew;
  }

  //textEditingControllers for setting init value
  //TODO: use more sophisticated way
  late final _titleTextEditingController = TextEditingController();
  late final _waterTextEditingController = TextEditingController();
  late final _temperatureTextEditingController = TextEditingController();
  late final _beanTextEditingController = TextEditingController();
  late final _grainTextEditingController = TextEditingController();

  var edittingRecipeData = RecipeData(title: "EmptyData", id: -1);

  @override
  Widget build(BuildContext context) {
    final mainStatus = context.watch<MainStatus>();
    final _focusNode = FocusNode();
    if (isNew) {
      debugPrint("New ID: ${mainStatus.nextId}");
    } else {
      _titleTextEditingController.text = recipeData.title;
      if (recipeData.water != null) {
        _waterTextEditingController.text = recipeData.water.toString();
      }
      if (recipeData.temperature != null) {
        _temperatureTextEditingController.text =
            recipeData.temperature.toString();
      }
      if (recipeData.bean != null) {
        _beanTextEditingController.text = recipeData.bean.toString();
      }
      if (recipeData.grain != null) {
        _grainTextEditingController.text = recipeData.grain.toString();
      }
    }
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: _focusNode.requestFocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text((isNew ? "Create" : "Edit")),
            actions: [
              IconButton(
                  onPressed: () {
                    debugPrint("Remove ID at: ${recipeData.id}");
                    mainStatus.removeById(recipeData.id);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: Icon(Icons.delete)),
              IconButton(onPressed: () {}, icon: Icon(Icons.restore)),
              IconButton(
                  onPressed: () {
                    if (!isNew) {
                      debugPrint("Change to ${edittingRecipeData.water}");
                      mainStatus.updateRecipeData(
                          recipeData.id, edittingRecipeData);
                    } else {
                      edittingRecipeData.setId(mainStatus.nextId);
                      debugPrint("Add Recipe: ${edittingRecipeData.id}");
                      mainStatus.addRecipeData(edittingRecipeData);
                    }
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: Icon(Icons.check)),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                      color: Theme.of(context).primaryColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            //TODO: Alignment these items
                            TextField(
                                controller: _titleTextEditingController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Recipe Name",
                                    hintText: "Enter Recipe Name",
                                    prefixIcon: Icon(Icons.abc),
                                    fillColor: Colors.grey),
                                keyboardType: TextInputType.text,
                                onChanged: (String value) {
                                  edittingRecipeData.title = value;
                                }),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 4),
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: _waterTextEditingController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Water",
                                        suffixText: "g",
                                        prefixIcon: Icon(Icons.water_drop),
                                      ),
                                      onChanged: (value) {
                                        edittingRecipeData.water = value.isEmpty
                                            ? null
                                            : int.parse(value);
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 4),
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller:
                                          _temperatureTextEditingController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Temperature",
                                        suffixText: "℃",
                                        prefixIcon: Icon(Icons.scale),
                                      ),
                                      onChanged: (value) {
                                        edittingRecipeData.temperature =
                                            value.isEmpty
                                                ? null
                                                : int.parse(value);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 4),
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: _beanTextEditingController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Bean",
                                        suffixText: "g",
                                        prefixIcon: Icon(Icons.scale),
                                      ),
                                      onChanged: (value) {
                                        edittingRecipeData.bean = value.isEmpty
                                            ? null
                                            : int.parse(value);
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 4),
                                    child: TextField(
                                      controller: _grainTextEditingController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "grain",
                                        prefixIcon: Icon(Icons.grain),
                                      ),
                                      onChanged: (value) {
                                        edittingRecipeData.grain =
                                            value.isEmpty ? null : value;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
