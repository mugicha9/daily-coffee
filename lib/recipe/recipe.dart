import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import 'recipe_card.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final arrayOfRecipeData = context.watch<MainStatus>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flexible(
            child: ListView(
                children: arrayOfRecipeData.arrayRecipeData
                    .map((recipeData) => (CoffeeRecipeCard(recipe: recipeData)))
                    .toList()),
          ),
        ],
      ),
    );
  }
}
