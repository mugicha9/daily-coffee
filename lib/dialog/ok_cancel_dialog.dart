import 'package:flutter/material.dart';

class OkCancelDialog extends StatelessWidget {
  final String title;
  final String content;
  const OkCancelDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}
