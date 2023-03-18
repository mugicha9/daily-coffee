import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MainStatus(),
        child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.brown,
              primaryColorDark: Colors.grey,
              primaryTextTheme:
                  const TextTheme(titleSmall: TextStyle(color: Colors.white)),
              focusColor: Colors.white,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color.fromARGB(255, 128, 95, 83),
                selectedItemColor: Colors.white,
                unselectedItemColor: Color.fromRGBO(176, 159, 152, 1),
              ),
              scaffoldBackgroundColor: Color.fromARGB(255, 128, 95, 83)),
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
                  color: Theme.of(context).primaryColorDark, child: appPage)),
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
        }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Pressed");
          },
          child: Icon(Icons.add)),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flexible(
        child: ListView(children: [
          CoffeeRecipeCard(),
          CoffeeRecipeCard(),
          CoffeeRecipeCard(),
          CoffeeRecipeCard(),
          CoffeeRecipeCard(),
          CoffeeRecipeCard()
        ]),
      ),
    );
  }
}

class CoffeeRecipeCard extends StatelessWidget {
  const CoffeeRecipeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                            style: Theme.of(context).textTheme.headlineSmall,
                            "OishiiCoffeeRecipe"),
                        Wrap(children: [
                          IngredientCard(
                              icon: Icon(Icons.water_drop), text: '210ml'),
                          IngredientCard(
                              icon: Icon(Icons.thermostat), text: "86℃"),
                          IngredientCard(
                              icon: Icon(Icons.grain), text: "Normal"),
                          IngredientCard(icon: Icon(Icons.scale), text: "14g"),
                          IngredientCard(
                              icon: Icon(Icons.timer_rounded), text: "3:00")
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            )),
        onTap: () {});
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

class MainStatus extends ChangeNotifier {}
