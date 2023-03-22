import 'package:flutter/material.dart';

class WithLabelDivider extends StatelessWidget {
  final String label;
  const WithLabelDivider({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                  width: double.infinity, child: Divider(color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child:
                  Text(label, style: Theme.of(context).textTheme.headlineSmall),
            ),
            Flexible(
              child: SizedBox(
                  width: double.infinity, child: Divider(color: Colors.black)),
            )
          ],
        ));
  }
}
