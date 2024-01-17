// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';

class FoodCardModal extends StatefulWidget {

  final String buttonLabel;
  final Function() onPressed;
  final Function(String) onChangeMealTime;
  final Function(int) onCounterChanged;

  const FoodCardModal({
    required this.buttonLabel,
    required this.onPressed,
    required this.onCounterChanged,
    required this.onChangeMealTime,
    super.key
  });

  @override
  State<FoodCardModal> createState() => _FoodCardModalState();
}

class _FoodCardModalState extends State<FoodCardModal> {
  String? mealTimeType;
  int _counter = 1;

  void onChanged(dynamic mealTime){
    if(mealTime is String)
      setState(() {
        mealTimeType = mealTime;
        widget.onChangeMealTime(mealTime);
      });
  }

  void updateCounter(bool add) => setState(() {
    if(add)
      _counter++;
    else if(_counter > 1)
      _counter--;
    widget.onCounterChanged(_counter);
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
            dropdownColor: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            hint: const Text("Meal time"),
            isExpanded: true,
            value: mealTimeType,
            onChanged: onChanged,
            items: const [
              DropdownMenuItem(value: 'breakfast', child: Text("Breakfast")),
              DropdownMenuItem(value: 'lunch', child: Text("Lunch")),
              DropdownMenuItem(value: 'snack', child: Text("Snack")),
              DropdownMenuItem(value: 'dinner', child: Text("Dinner")),
              DropdownMenuItem(value: 'appetizer', child: Text("Appetizer")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Portions"),
              Counter(
                counter: _counter,
                add: () => updateCounter(true),
                remove: () => updateCounter(false)
              )
            ],
          ),
          MaterialButton(
            elevation: 2,
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

class Counter extends StatelessWidget {
  final int counter;
  final Function() add;
  final Function() remove;

  const Counter({
    required this.counter,
    required this.add,
    required this.remove,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        button(this.remove, Icons.remove),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(this.counter.toString()),
        ),
        button(this.add, Icons.add)
      ],
    );
  }

  Widget button(Function() onPressed, IconData iconData) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      color: Colors.white24,
      elevation: 0,
      minWidth: 30,
      height: 30,
      onPressed: onPressed,
      child: Icon(iconData)
    );
  }
}