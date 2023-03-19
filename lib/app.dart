import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe/recipe_card.dart';
import 'recipe/recipe_edit.dart';
import 'recipe/recipe.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MainStatus(),
        child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.brown,
              primaryColorLight: Color.fromRGBO(204, 159, 129, 1),
              primaryColorDark: Colors.grey,
              primaryTextTheme:
                  const TextTheme(titleSmall: TextStyle(color: Colors.white)),
              focusColor: Colors.white,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color.fromRGBO(128, 95, 83, 1),
                selectedItemColor: Colors.white,
                unselectedItemColor: Color.fromRGBO(176, 159, 152, 1),
              ),
              scaffoldBackgroundColor: Color.fromRGBO(128, 95, 83, 1)),
          title: "Daily-Coffe",
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var isFloatingButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    Widget appPage;
    switch (selectedIndex) {
      case 0:
        appPage = RecipePage();
        break;
      case 1:
        appPage = TimerPage();
        break;
      case 2:
        appPage = BeanPage();
        break;
      case 3:
        appPage = SettingPage();
        break;
      default:
        throw UnimplementedError("No widget for index $selectedIndex");
    }
    return Scaffold(
      body: Column(
        children: [
          SafeArea(child: Container(color: Theme.of(context).primaryColor)),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      image: const DecorationImage(
                          image: AssetImage(
                              './assets/images/background_image_1.png'),
                          fit: BoxFit.cover)),
                  child: appPage)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.coffee_outlined),
              activeIcon: Icon(Icons.coffee),
              label: 'Recipe'),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              label: 'Timer'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined),
              activeIcon: Icon(Icons.inbox),
              label: 'Beans'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Setting'),
        ],
        currentIndex: selectedIndex,
        onTap: (value) => setState(() {
          selectedIndex = value;
          if (value != 0) {
            isFloatingButtonVisible = false;
          } else {
            isFloatingButtonVisible = true;
          }
        }),
      ),
      floatingActionButton: Visibility(
        visible: isFloatingButtonVisible,
        child: FloatingActionButton(
            splashColor: Theme.of(context).primaryColorLight,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipeEditPage()));
            },
            child: Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class RecipePage extends StatelessWidget {
  const RecipePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CoffeeRecipeCard recipeCardDummy = CoffeeRecipeCard(
      recipe: RecipeData(
          title: "OishiiCoffeeRecipe",
          water: 210,
          temperature: 86,
          bean: 14,
          timeSecond: 300,
          grain: "Normal"),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flexible(
            child: ListView(
                children: [for (int i = 0; i < 10; i++) recipeCardDummy]),
          ),
        ],
      ),
    );
  }
}

class TimerPage extends StatelessWidget {
  const TimerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Timer'),
    );
  }
}

class BeanPage extends StatelessWidget {
  const BeanPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Bean'),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Setting'),
    );
  }
}

class MainStatus extends ChangeNotifier {
  var isVisibleFloatingButton = true;

  setFloatingButtonVisible(bool isVisible) {
    isVisibleFloatingButton = isVisible;
    notifyListeners();
  }
}
