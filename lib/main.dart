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

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            child: Text('Hello World!'),
          ),
          SafeArea(
              child: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.coffee), label: 'Recipe'),
              NavigationDestination(icon: Icon(Icons.book), label: 'Make'),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: 'Setting'),
            ],
          ))
        ],
      ),
    );
  }
}

class MainStatus extends ChangeNotifier {
  var selectedIndex = 0;
}
