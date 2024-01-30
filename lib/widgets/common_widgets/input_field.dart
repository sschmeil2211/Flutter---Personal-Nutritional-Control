// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personal_nutrition_control/utils/utils.dart';

class InputField extends StatelessWidget {

  final bool obscureText;
  final bool readOnly;
  final Function()? onPressedIcon;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final IconData prefixIcon;
  final String labelText;
  final TextEditingController textEditingController;
  final TextInputType? textInputType;

  const InputField({
    this.textInputType,
    this.readOnly = false,
    this.obscureText = false,
    this.onPressedIcon,
    this.onTap,
    this.inputFormatters,
    required this.prefixIcon,
    required this.labelText,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        keyboardType: this.textInputType,
        controller: this.textEditingController,
        obscureText: this.obscureText,
        readOnly: this.readOnly,
        inputFormatters: this.inputFormatters,
        onTap: this.onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(this.prefixIcon),
          labelText: this.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          suffixIcon: suffixIcon()
        ),
      ),
    );
  }

  Widget? suffixIcon() => this.onPressedIcon != null
      ? IconButton(onPressed: onPressedIcon, icon: const Icon(Icons.remove_red_eye_sharp))
      : null;
}

class EnumSelector<T> extends StatelessWidget {
  final List<T> enumValues;
  final String? title;

  const EnumSelector({
    required this.enumValues,
    this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var value in enumValues)
            ListTile(
              title: Text(formatEnumName(value)), // Extracts the enum name
              onTap: () => Navigator.pop(context, value),
            ),
          if(this.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                this.title!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class FoodInput extends StatelessWidget {
  final bool isNumberInput;
  final TextEditingController controller;
  final String? label;
  final Color color;

  const FoodInput({
    this.isNumberInput = true,
    required this.color,
    required this.controller,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: width, maxWidth: width,
            minHeight: 40, maxHeight: 40
        ),
        child: TextFormField(
          keyboardType: this.isNumberInput ? const TextInputType.numberWithOptions(signed: false, decimal: true) : TextInputType.text,
          controller: this.controller,
          style: TextStyle(color: this.color, fontWeight: FontWeight.w600),
          inputFormatters: this.isNumberInput ? [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))] : null,
          decoration: InputDecoration(
            labelText: this.label,
            labelStyle: TextStyle(color: this.color),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
            ),
          ),
        ),
      ),
    );
  }
}
