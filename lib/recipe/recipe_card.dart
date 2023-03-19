import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_edit.dart';

class CoffeeRecipeCard extends StatelessWidget {
  const CoffeeRecipeCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final RecipeData recipe;

  @override
  Widget build(BuildContext context) {
    //Build IngredientCard
    var ingredientCards = <IngredientCard>[];

    if (recipe.water != -1) {
      ingredientCards.add(IngredientCard(
          icon: const Icon(Icons.water_drop), text: "${recipe.water}ml"));
    }
    if (recipe.temperature != -1) {
      ingredientCards.add(IngredientCard(
          icon: Icon(Icons.thermostat), text: "${recipe.temperature}℃"));
    }
    if (recipe.bean != -1) {
      ingredientCards.add(
          IngredientCard(icon: Icon(Icons.scale), text: "${recipe.bean}g"));
    }

    if (recipe.grain != "") {
      ingredientCards
          .add(IngredientCard(icon: Icon(Icons.grain), text: recipe.grain));
    }
    if (recipe.timeSecond != -1) {
      ingredientCards.add(IngredientCard(
          icon: Icon(Icons.timer_rounded), text: "${recipe.timeSecond}s"));
    }

    return GestureDetector(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(10),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.image_outlined, size: 80),
                  Container(
                    height: 80,
                    child: VerticalDivider(
                      color: Colors.black,
                    ),
                  ),
                  Flexible(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                              style: Theme.of(context).textTheme.headlineSmall,
                              recipe.title),
                          Wrap(children: ingredientCards)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
        onTap: () {
          //TODO: Make Edit Page. (Load existed Recipe and fill by it)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecipeEditPage()));
        });
  }
}

class IngredientCard extends StatelessWidget {
  final Icon icon;
  final String text;

  const IngredientCard({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: Color.fromARGB(255, 218, 209, 209),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(style: Theme.of(context).textTheme.labelMedium, text),
              SizedBox(
                width: 3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
