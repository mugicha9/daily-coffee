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
              primaryColorDark: Colors.blueGrey,
              primaryTextTheme:
                  const TextTheme(titleSmall: TextStyle(color: Colors.white)),
              focusColor: Colors.white,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color.fromARGB(255, 128, 95, 83),
                selectedItemColor: Colors.white,
                unselectedItemColor: Color.fromRGBO(176, 159, 152, 1),
              ),
              scaffoldBackgroundColor: Color.fromARGB(255, 209, 145, 103)),
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
        appPage = MakePage();
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
                  color: Theme.of(context).canvasColor, child: appPage)),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.coffee_outlined),
                  activeIcon: Icon(Icons.coffee),
                  label: 'Recipe'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.coffee_maker_outlined),
                  activeIcon: Icon(Icons.coffee_maker),
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
          )
        ],
      ),
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

class MakePage extends StatelessWidget {
  const MakePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Make'),
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

class RecipePage extends StatelessWidget {
  const RecipePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Recipe'),
    );
  }
}

class MainStatus extends ChangeNotifier {}
