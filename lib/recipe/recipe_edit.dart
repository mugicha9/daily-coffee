import 'package:daily_coffee/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daily_coffee/recipe/recipe_card.dart';
import 'recipe.dart';

class RecipeEditPage extends StatefulWidget {
  final int id;
  final bool isNew;
  const RecipeEditPage({Key? key, required this.id, required this.isNew})
      : super(key: key);

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  // TODO: 1. Make this.

  late int id;
  late bool isNew;

  @override
  void initState() {
    super.initState();

    id = widget.id;
    isNew = widget.isNew;
  }

  var edittingRecipeData = RecipeData(title: "EmptyData", id: -1);

  @override
  Widget build(BuildContext context) {
    final mainStatus = context.watch<MainStatus>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Edit"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.restore)),
          IconButton(
              onPressed: () {
                if (!isNew) {
                  setState(() {
                    debugPrint("Change Title to ${edittingRecipeData.title}");
                    edittingRecipeData.copyFrom(mainStatus.findById(id));
                    mainStatus.updateRecipeData(id, edittingRecipeData);
                  });
                }
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Recipe Name",
                              hintText: "Enter Recipe Name",
                              fillColor: Colors.grey),
                          keyboardType: TextInputType.text,
                          onTapOutside: (event) =>
                              {FocusScope.of(context).unfocus()},
                          onSubmitted: (String value) {
                            setState(() {
                              edittingRecipeData.title = value;
                            });
                          },
                        )
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
