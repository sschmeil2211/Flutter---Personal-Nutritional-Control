// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/extensions/extensions.dart';

class FoodCardModal extends StatefulWidget {

  final String buttonLabel;
  final Function() onPressed;
  final Function(String) onChangeMealTime;
  final Function(String) onKeyboardTap;

  const FoodCardModal({
    required this.buttonLabel,
    required this.onKeyboardTap,
    required this.onPressed,
    required this.onChangeMealTime,
    super.key
  });

  @override
  State<FoodCardModal> createState() => _FoodCardModalState();
}

class _FoodCardModalState extends State<FoodCardModal> {
  String mealTimeType = '';
  String text = '';

  void onChanged(String mealTime) => setState(() {
    mealTimeType = mealTime;
    widget.onChangeMealTime(mealTime);
  });

  void onKeyboardTap(String value) => setState(() {
    text = text + value;
    widget.onKeyboardTap(text);
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MealTimeGrid(selectedWord: mealTimeType, onPressed: onChanged),
          Text(
            text.isEmpty ? '0 g' : '$text g',
            style: const TextStyle(fontSize: 18),
          ),
          NumericKeyboard(
            onKeyboardTap: onKeyboardTap,
            rightButtonFn: () {
              if (text.isEmpty) return;
              setState(() => text = text.substring(0, text.length - 1));
            },
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            color: Colors.deepPurple,
            onPressed: widget.onPressed,
            child: Text(widget.buttonLabel),
          )
        ],
      ),
    );
  }
}

class MealTimeGrid extends StatelessWidget {
  final String selectedWord;
  final Function(String) onPressed;

  const MealTimeGrid({
    required this.selectedWord,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Select meal time',
            style: TextStyle(fontSize: 16),
          ),
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3,
          ),
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            String word = getMealTime(index);
            bool isSelected = word == selectedWord;
            return MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: isSelected ? Colors.white24 : Colors.white12,
              onPressed: () => onPressed(word),
              child: Text(word.capitalize()),
            );
          },
        ),
      ],
    );
  }
}

class NumericKeyboard extends StatelessWidget {
  final Function() rightButtonFn;
  final Function(String) onKeyboardTap;

  const NumericKeyboard({
    required this.onKeyboardTap,
    required this.rightButtonFn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', '⌫'],
        ])
          ButtonBar(
            buttonPadding: const EdgeInsets.symmetric(vertical: 15),
            alignment: MainAxisAlignment.spaceAround,
            children: [
              for (var value in row)
                TextButton(
                  onPressed: () => value == '⌫' ? rightButtonFn() : onKeyboardTap(value),
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}