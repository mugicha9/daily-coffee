import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './recipe/recipe.dart';
import 'recipe/recipe_detail.dart';
import 'recipe/recipe_data.dart';

import 'timer/timer.dart';

import 'setting/setting_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MainStatus(),
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            //AppBar
            appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
            //FAB
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                foregroundColor: Colors.white),
            //primary
            primaryColor: Colors.brown,
            primaryColorLight: Color.fromRGBO(213, 206, 198, 1),
            primaryColorDark: Colors.grey,
            //text
            primaryTextTheme: const TextTheme(
                titleSmall: TextStyle(color: Colors.white),
                headlineSmall: TextStyle(
                  color: Colors.black,
                )),
            focusColor: Colors.white,
            //divide
            dividerColor: Colors.transparent,
            //bottomNavigationBar
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(128, 95, 83, 1),
              selectedItemColor: Colors.white,
              unselectedItemColor: Color.fromRGBO(176, 159, 152, 1),
            ),
            //scaffold
            scaffoldBackgroundColor: Color.fromRGBO(128, 95, 83, 1),
          ),
          title: "Daily-Coffe",
          home: const MyHomePage(),
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
  //default is 0 but set 1 for debug
  var selectedIndex = 1;
  var isFloatingButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    var mainStatus = context.watch<MainStatus>();
    Widget appPage;
    switch (selectedIndex) {
      case 0:
        appPage = const RecipePage();
        isFloatingButtonVisible = true;
        break;
      case 1:
        appPage = const TimerPage();
        break;
      case 2:
        appPage = const BeanPage();
        break;
      case 3:
        appPage = const SettingPage();
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
                  /*decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      image: const DecorationImage(
                          image: AssetImage(
                              './assets/images/background_image_1.png'),
                          fit: BoxFit.cover)),*/
                  color: Theme.of(context).primaryColorLight,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeDetailWidget(
                            recipeData: RecipeData(
                                id: mainStatus.nextId, title: "NewRecipe"),
                            isNew: true,
                          )));
            },
            child: const Icon(Icons.note_add_outlined)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class BeanPage extends StatelessWidget {
  const BeanPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Bean'),
    );
  }
}

class MainStatus extends ChangeNotifier {
  var arrayRecipeData = <RecipeData>[];
  var nextId = 0;

  RecipeData findById(int id) {
    for (int i = 0; i < arrayRecipeData.length; i++) {
      if (arrayRecipeData[i].id == id) {
        return arrayRecipeData[i];
      }
    }
    throw Error();
  }

  void updateRecipeData(int id, RecipeData newData) {
    for (int i = 0; i < arrayRecipeData.length; i++) {
      if (arrayRecipeData[i].id == id) {
        debugPrint("update to NewData(${newData.title})");
        arrayRecipeData[i] = newData;
      }
      notifyListeners();
    }
  }

  void addRecipeData(RecipeData newData) {
    arrayRecipeData.add(newData);
    nextId++;

    notifyListeners();
  }

  void removeById(int id) {
    var target = findById(id);
    arrayRecipeData.remove(target);

    notifyListeners();
  }

  void resetAllData() {
    arrayRecipeData.clear();
    nextId = 0;
  }
}
