import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'recipe_data.dart';

class RecipeEditTextField extends StatelessWidget {
  const RecipeEditTextField({
    super.key,
    required TextEditingController controller,
    required this.labelText,
    required this.isEdit,
    required this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.suffixText,
    this.formatters,
  }) : textEditingController = controller;

  final TextEditingController textEditingController;
  final bool isEdit;

  final String labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final String? suffixText;

  final List<TextInputFormatter>? formatters;

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: textEditingController,
        inputFormatters: formatters,
        enabled: isEdit,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            hintText: hintText,
            suffixText: suffixText,
            prefixIcon: prefixIcon,
            fillColor: Colors.grey),
        keyboardType: TextInputType.text,
        onChanged: (String value) {
          onChanged(value);
        });
  }
}
