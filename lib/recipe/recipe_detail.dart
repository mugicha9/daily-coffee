import 'package:daily_coffee/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'recipe_data.dart';
import 'recipe_inputfield.dart';

class RecipeDetailPage extends StatefulWidget {
  final RecipeData recipeData;
  final bool isNew;
  const RecipeDetailPage(
      {Key? key, required this.recipeData, required this.isNew})
      : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late RecipeData recipeData;
  late bool isNew;
  late bool isEdit;

  //textEditingControllers for setting init value
  //TODO: use more sophisticated way
  // Move contorller to child widget like "IngredientEditInputField"
  // Use child method through GlobalKey and get field's value?

  // Or Use RecipeDetailStatus, extending ChangeNotifier

  late final _titleTextEditingController = TextEditingController();
  late final _waterTextEditingController = TextEditingController();
  late final _temperatureTextEditingController = TextEditingController();
  late final _beanTextEditingController = TextEditingController();
  late final _grainTextEditingController = TextEditingController();

  late final _controllers = <TextEditingController>[];

  late RecipeData edittingRecipeData;
  var processItems = <Widget>[ProcessItem()];

  @override
  void initState() {
    super.initState();

    recipeData = widget.recipeData;
    isNew = widget.isNew;
    isEdit = isNew;

    _controllers.addAll([
      _titleTextEditingController,
      _waterTextEditingController,
      _temperatureTextEditingController,
      _beanTextEditingController,
      _grainTextEditingController,
    ]);

    initTextField();
    initEdittingRecipeData();
  }

  @override
  void dispose() {
    super.dispose();
    for (var c in _controllers) {
      c.dispose();
    }
  }

  void initEdittingRecipeData() {
    edittingRecipeData = recipeData.copyWith();
  }

  void updateBaseRecipeData() {
    recipeData = edittingRecipeData.copyWith();
  }

  void initTextField() {
    if (!isNew) {
      _titleTextEditingController.text = recipeData.title;
      if (recipeData.water != null) {
        _waterTextEditingController.text = recipeData.water.toString();
      } else {
        _waterTextEditingController.text = "";
      }
      if (recipeData.temperature != null) {
        _temperatureTextEditingController.text =
            recipeData.temperature.toString();
      } else {
        _temperatureTextEditingController.text = "";
      }
      if (recipeData.bean != null) {
        _beanTextEditingController.text = recipeData.bean.toString();
      } else {
        _beanTextEditingController.text = "";
      }
      if (recipeData.grain != null) {
        _grainTextEditingController.text = recipeData.grain.toString();
      } else {
        _grainTextEditingController.text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainStatus = context.watch<MainStatus>();

    return ChangeNotifierProvider(
      create: (context) => RecipeDetailStatus(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text((isNew
                ? "Create"
                : (isEdit ? "Edit" : edittingRecipeData.title))),
            actions: [
              IconButton(
                  onPressed: () {
                    debugPrint("Remove ID at: ${recipeData.id}");
                    if (!isNew) mainStatus.removeById(recipeData.id);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: Icon(Icons.delete)),
              Visibility(
                  visible: !isNew && isEdit,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          initTextField();
                          initEdittingRecipeData();
                        });
                      },
                      icon: Icon(Icons.restore))),
              Visibility(
                  visible: !isEdit,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isEdit = true;
                        });
                      },
                      icon: Icon(Icons.edit))),
              Visibility(
                visible: isEdit,
                child: IconButton(
                    onPressed: () {
                      if (!isNew) {
                        mainStatus.updateRecipeData(
                            recipeData.id, edittingRecipeData);
                        updateBaseRecipeData();
                      } else {
                        edittingRecipeData.setId(mainStatus.nextId);
                        debugPrint("Add Recipe: ${edittingRecipeData.id}");
                        mainStatus.addRecipeData(edittingRecipeData);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                      setState(() {
                        isEdit = false;
                      });
                    },
                    icon: Icon(Icons.check)),
              ),
            ],
          ),
          body: Column(
            children: [
              Flexible(
                  child: Container(
                      color: Theme.of(context).primaryColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          children: [
                            //TODO: Alignment these items
                            WithLabelDivider(label: "Recipe Overview"),
                            RecipeEditTextField(
                              controller: _titleTextEditingController,
                              labelText: "Recipe Name",
                              hintText: "Enter Recipe Name",
                              prefixIcon: Icon(Icons.abc),
                              isEdit: isEdit,
                              onChanged: ((String value) =>
                                  {edittingRecipeData.title = value}),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 4),
                                    child: RecipeEditTextField(
                                      isEdit: isEdit,
                                      formatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: _waterTextEditingController,
                                      labelText: "Water",
                                      suffixText: "g",
                                      prefixIcon: Icon(Icons.water_drop),
                                      onChanged: (String value) {
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
                                    child: RecipeEditTextField(
                                      controller:
                                          _temperatureTextEditingController,
                                      formatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      labelText: "Temperature",
                                      suffixText: "℃",
                                      prefixIcon: Icon(Icons.thermostat),
                                      isEdit: isEdit,
                                      onChanged: (String value) {
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
                                    child: RecipeEditTextField(
                                      isEdit: isEdit,
                                      formatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: _beanTextEditingController,
                                      labelText: "Bean",
                                      suffixText: "g",
                                      prefixIcon: Icon(Icons.scale),
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
                                    child: RecipeEditTextField(
                                      isEdit: isEdit,
                                      controller: _grainTextEditingController,
                                      labelText: "grain",
                                      prefixIcon: Icon(Icons.grain),
                                      onChanged: (value) {
                                        edittingRecipeData.grain =
                                            value.isEmpty ? "" : value;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            WithLabelDivider(label: "Process"),
                            ...processItems,
                            AddProcessItem(),
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

class RecipeDetailStatus extends ChangeNotifier {}

class WithLabelDivider extends StatelessWidget {
  final String label;
  const WithLabelDivider({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                  width: double.infinity, child: Divider(color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child:
                  Text(label, style: Theme.of(context).textTheme.headlineSmall),
            ),
            Flexible(
              child: SizedBox(
                  width: double.infinity, child: Divider(color: Colors.black)),
            )
          ],
        ));
  }
}

class AddProcessItem extends StatefulWidget {
  const AddProcessItem({
    super.key,
  });

  @override
  State<AddProcessItem> createState() => _AddProcessItemState();
}

class _AddProcessItemState extends State<AddProcessItem>
    with SingleTickerProviderStateMixin {
  var isSelected = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              style: IconButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: ContinuousRectangleBorder()),
              onPressed: () {},
            )
          ]),
    );
  }
}

//TODO: Improve UI Design
//    : Separete file
class ProcessItem extends StatefulWidget {
  const ProcessItem({
    super.key,
  });

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {
  String showText = "Pour";
  String suffixText = "g";
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(212, 188, 141, 1),
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
                onChanged: (String? value) => {
                  setState(
                    () {
                      showText = value ?? "NULL";
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
                },
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Attribute",
                      prefixIcon: Icon(Icons.onetwothree),
                      suffixText: suffixText),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
