import 'package:daily_coffee/recipe/recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecipeEditTextField extends StatelessWidget {
  const RecipeEditTextField({
    super.key,
    required TextEditingController controller,
    required this.labelText,
    required this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.suffixText,
    this.formatters,
    this.keyboardType,
  }) : textEditingController = controller;

  final TextEditingController textEditingController;

  final String labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final String? suffixText;
  final TextInputType? keyboardType;

  final List<TextInputFormatter>? formatters;

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    var detailStatus = context.watch<RecipeDetailStatus>();
    return TextField(
        controller: textEditingController,
        inputFormatters: formatters,
        enabled: detailStatus.isEdit,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            hintText: hintText,
            suffixText: suffixText,
            prefixIcon: prefixIcon,
            fillColor: Colors.grey),
        keyboardType: keyboardType,
        onChanged: (String value) {
          onChanged(value);
        });
  }
}
