import 'package:daily_coffee/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainStatus = context.watch<MainStatus>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Setting'),
            const Text("Debugs"),
            ElevatedButton(
                onPressed: () {
                  debugPrint("Delete All Data.");
                  mainStatus.resetAllData();
                },
                child: const Text("Reset All Data"))
          ],
        ),
      ),
    );
  }
}
