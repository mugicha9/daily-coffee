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

  late final _titleTextEditingController = TextEditingController();
  late final _waterTextEditingController = TextEditingController();
  late final _temperatureTextEditingController = TextEditingController();
  late final _beanTextEditingController = TextEditingController();
  late final _grainTextEditingController = TextEditingController();
  late final _takeTimeTextEditingController = TextEditingController();
  late final _yieldTextEditingController = TextEditingController();

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
      _takeTimeTextEditingController,
      _yieldTextEditingController,
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
    var detailStatus = context.watch<RecipeDetailStatus>();
    _takeTimeTextEditingController.text =
        "${detailStatus.getTime().inMinutes % 60}:${detailStatus.getTime().inSeconds % 60}";
    _yieldTextEditingController.text = "${detailStatus.getWaterAmount()}";
    edittingRecipeData.timeSecond = detailStatus.getTime().inSeconds;
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
                        detailStatus.getArrayProcessData();
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
                        ExpansionTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          initiallyExpanded: true,
                          title: Text(
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                              "Recipe Overview"),
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            RecipeEditTextField(
                              controller: _titleTextEditingController,
                              labelText: "Recipe Name",
                              hintText: "Enter Recipe Name",
                              prefixIcon: Icon(Icons.abc),
                              onChanged: ((String value) =>
                                  {edittingRecipeData.title = value}),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Flexible(
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
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
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
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Flexible(
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
                                SizedBox(width: 8),
                                Flexible(
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
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Divider(
                                        color: Colors.grey,
                                      )),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: TextField(
                                  controller: _takeTimeTextEditingController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.timer),
                                      labelText: "take"),
                                )),
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                    child: TextField(
                                  controller: _yieldTextEditingController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.coffee),
                                      suffixText: "g",
                                      labelText: "yield"),
                                ))
                              ],
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                              "Process"),
                          children: [
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              Theme(
                                data: ThemeData(
                                  //transparent background for ReorderableListView
                                  canvasColor: Colors.transparent,
                                ),
                                child: ReorderableListView(
                                  buildDefaultDragHandles: detailStatus.isEdit,
                                  shrinkWrap: true,
                                  children: detailStatus.arrayProcessItemField
                                      .map((e) {
                                    return ProcessItem(
                                        key: Key("${e.id}"),
                                        recipeProcessData: e.recipeProcessData,
                                        textController: e.controller);
                                  }).toList(),
                                  onReorder: (oldIndex, newIndex) {
                                    detailStatus.onReorder(oldIndex, newIndex);
                                  },
                                ),
                              ),
                              AddProcessItem()
                            ]),
                          ],
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class RecipeDetailStatus extends ChangeNotifier {
  var nextProcessID = 0;
  var isEdit = true;
  List<ProcessItemField> arrayProcessItemField = [];

  RecipeDetailStatus(bool b, List<RecipeProcessData>? ps) {
    int i = 0;
    isEdit = b;

    ps?.asMap().forEach((i, value) {
      arrayProcessItemField.add(ProcessItemField(
          i, value, TextEditingController(text: value.value?.toString())));
    });
    nextProcessID = i;
  }

  void toggleEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  void addNewProcess() {
    arrayProcessItemField.add(ProcessItemField(nextProcessID,
        RecipeProcessData(id: nextProcessID), TextEditingController()));
    nextProcessID++;
    notifyListeners();
  }

  void removeProcess(RecipeProcessData rpd) {
    var targetProcess = arrayProcessItemField
        .where((element) => element.recipeProcessData == rpd);
    arrayProcessItemField = arrayProcessItemField
        .where((element) => (element.recipeProcessData != rpd))
        .toList();
    for (var element in targetProcess) {
      element.dispose();
    }
    notifyListeners();
  }

  void updateProcess(int id, String? label, int? value, Duration? time) {
    var target = findById(id);
    target.label = label ?? target.label;
    target.value = value ?? target.value;
    target.time = time ?? target.time;

    debugPrint(
        "[Status Updated] ${target.id}, ${target.label}, ${target.value}");

    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ProcessItemField item = arrayProcessItemField.removeAt(oldIndex);
    arrayProcessItemField.insert(newIndex, item);
    for (int i = 0; i < arrayProcessItemField.length; i++) {
      arrayProcessItemField[i].recipeProcessData.id = i;
    }

    notifyListeners();
  }

  RecipeProcessData findById(int id) {
    for (int i = 0; i < arrayProcessItemField.length; i++) {
      if (arrayProcessItemField[i].recipeProcessData.id == id) {
        return arrayProcessItemField[i].recipeProcessData;
      }
    }
    throw Error();
  }

  List<RecipeProcessData> getArrayProcessData() {
    List<RecipeProcessData> ret = [];
    for (var item in arrayProcessItemField) {
      ret.add(item.recipeProcessData);
    }
    return ret;
  }

  int getWaterAmount() {
    int sumWater = 0;
    for (int i = 0; i < arrayProcessItemField.length; i++) {
      if (arrayProcessItemField[i].recipeProcessData.label == "Pour") {
        sumWater += arrayProcessItemField[i].recipeProcessData.value ?? 0;
      }
    }
    return sumWater;
  }

  Duration getTime() {
    Duration sumTime = Duration.zero;
    for (int i = 0; i < arrayProcessItemField.length; i++) {
      if (arrayProcessItemField[i].recipeProcessData.label == "Wait") {
        sumTime +=
            arrayProcessItemField[i].recipeProcessData.time ?? Duration.zero;
      }
    }
    return sumTime;
  }

  List<ProcessItem> buildProcessItem() {
    return arrayProcessItemField
        .map(
          (e) => ProcessItem(
              key: Key("${e.id}"),
              recipeProcessData: e.recipeProcessData,
              textController: e.controller),
        )
        .toList();
  }

  void debugProcess() {
    for (int i = 0; i < arrayProcessItemField.length; i++) {
      debugPrint(
          "[Status] ID: ${arrayProcessItemField[i].id}, label: ${arrayProcessItemField[i].recipeProcessData.label}, value: ${arrayProcessItemField[i].recipeProcessData.value}");
    }
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
                  side: BorderSide(
                      color: detailStatus.isEdit ? Colors.black : Colors.grey),
                  shape: ContinuousRectangleBorder()),
              onPressed: detailStatus.isEdit
                  ? () {
                      detailStatus.addNewProcess();
                    }
                  : null,
            )
          ]),
    );
  }
}
