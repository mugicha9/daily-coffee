import 'package:daily_coffee/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'recipe_data.dart';
import 'recipe_inputfield.dart';
import 'recipe_process.dart';

class RecipeDetailWidget extends StatelessWidget {
  final RecipeData recipeData;
  final bool isNew;
  const RecipeDetailWidget(
      {Key? key, required this.recipeData, required this.isNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            RecipeDetailStatus(isNew, recipeData.processSequence),
        child: RecipeDetailPage(
          recipeData: recipeData,
          isNew: isNew,
        ));
  }
}

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

  @override
  void initState() {
    super.initState();

    recipeData = widget.recipeData;
    isNew = widget.isNew;

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
    final detailStatus = context.watch<RecipeDetailStatus>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text((isNew
              ? "Create"
              : (detailStatus.isEdit ? "Edit" : edittingRecipeData.title))),
          actions: [
            IconButton(
                onPressed: () {
                  if (!isNew) mainStatus.removeById(recipeData.id);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: Icon(Icons.delete)),
            Visibility(
                visible: !isNew && detailStatus.isEdit,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        initTextField();
                        initEdittingRecipeData();
                      });
                    },
                    icon: Icon(Icons.restore))),
            Visibility(
                visible: !detailStatus.isEdit,
                child: IconButton(
                    onPressed: () {
                      detailStatus.toggleEdit();
                    },
                    icon: Icon(Icons.edit))),
            Visibility(
              visible: detailStatus.isEdit,
              child: IconButton(
                  onPressed: () {
                    if (!isNew) {
                      mainStatus.updateRecipeData(
                          recipeData.id, edittingRecipeData);
                      updateBaseRecipeData();
                    } else {
                      edittingRecipeData.setId(mainStatus.nextId);
                      mainStatus.addRecipeData(edittingRecipeData);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                    edittingRecipeData.processSequence =
                        detailStatus.arrayProcessData;
                    detailStatus.toggleEdit();
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
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: _waterTextEditingController,
                                    keyboardType: TextInputType.number,
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
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 4),
                                  child: RecipeEditTextField(
                                    controller:
                                        _temperatureTextEditingController,
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    labelText: "Temperature",
                                    suffixText: "℃",
                                    prefixIcon: Icon(Icons.thermostat),
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
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: _beanTextEditingController,
                                    keyboardType: TextInputType.number,
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
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 4),
                                  child: RecipeEditTextField(
                                    controller: _grainTextEditingController,
                                    keyboardType: TextInputType.text,
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
                          Column(children: detailStatus.buildProcessItem()),
                          AddProcessItem(),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}

class RecipeDetailStatus extends ChangeNotifier {
  var nextProcessID = 0;
  var isEdit = true;
  late List<RecipeProcessData> arrayProcessData;
  RecipeDetailStatus(bool b, List<RecipeProcessData>? ps) {
    isEdit = b;
    arrayProcessData = ps ?? [];
  }

  void toggleEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  void setEdit(bool b) {
    isEdit = b;
    notifyListeners();
  }

  void publishNewProcess() {
    arrayProcessData.add(RecipeProcessData(id: nextProcessID));
    nextProcessID++;
    notifyListeners();
  }

  void updateProcess(int id, String? label, int? value) {
    var target = findById(id);
    target.label = label ?? target.label;
    target.value = value ?? target.value;
  }

  RecipeProcessData findById(int id) {
    for (int i = 0; i < arrayProcessData.length; i++) {
      if (arrayProcessData[i].id == id) {
        return arrayProcessData[i];
      }
    }
    throw Error();
  }

  void removeProcess(int id) {
    for (int i = 0; i < arrayProcessData.length; i++) {
      if (arrayProcessData[i].id == id) {
        arrayProcessData.remove(arrayProcessData[i]);
      }
    }
    notifyListeners();
  }

  List<ProcessItem> buildProcessItem() {
    debugProcess();
    return arrayProcessData
        .map((e) => ProcessItem(id: e.id, label: e.label, value: e.value))
        .toList();
  }

  void debugProcess() {
    for (int i = 0; i < arrayProcessData.length; i++) {
      debugPrint(
          "[Status] ID: ${arrayProcessData[i].id}, label: ${arrayProcessData[i].label}, value: ${arrayProcessData[i].value}");
    }
  }
}

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
    var detailStatus = context.watch<RecipeDetailStatus>();
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
              onPressed: () {
                detailStatus.publishNewProcess();
              },
            )
          ]),
    );
  }
}
