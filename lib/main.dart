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
        child: const MaterialApp(
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
        appPage = SettingPage();
        break;
      default:
        throw UnimplementedError("No widget for index $selectedIndex");
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: appPage,
          ),
          SafeArea(
              child: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: 'Recipe'),
              NavigationDestination(
                  icon: Icon(Icons.coffee_outlined),
                  selectedIcon: Icon(Icons.coffee),
                  label: 'Make'),
              NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Setting'),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) => setState(() {
              selectedIndex = value;
            }),
          ))
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
