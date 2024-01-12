// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_nutrition_control/models/user_model.dart';

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
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon()
        ),
      ),
    );
  }

  Widget? suffixIcon() => this.onPressedIcon != null
      ? IconButton(onPressed: onPressedIcon, icon: const Icon(Icons.remove_red_eye_sharp))
      : null;
}

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Male'),
            onTap: () => Navigator.pop(context, GenreType.male) ,
          ),
          ListTile(
            title: const Text('Female'),
            onTap: () => Navigator.pop(context, GenreType.female) ,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              '* We need your biological gender for some calculations.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class PhysicalTimeSelector extends StatelessWidget {
  const PhysicalTimeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Less than 1 hs'),
            onTap: () => Navigator.pop(context,  PhysicalActivity.lessThanHour),
          ),
          ListTile(
            title: const Text('2 to 5 hs'),
            onTap: () => Navigator.pop(context, PhysicalActivity.twoToFive),
          ),
          ListTile(
            title: const Text('6 to 9 hs'),
            onTap: () => Navigator.pop(context, PhysicalActivity.sixToNine),
          ),
          ListTile(
            title: const Text('10 to 20 hs'),
            onTap: () => Navigator.pop(context, PhysicalActivity.tenToTwenty),
          ),
          ListTile(
            title: const Text('More than 20 hs'),
            onTap: () => Navigator.pop(context, PhysicalActivity.moreThanTwenty),
          ),
        ],
      ),
    );
  }
}