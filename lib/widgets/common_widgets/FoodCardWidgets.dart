// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/FoodModel.dart';

class FoodCard extends StatelessWidget {

  final Widget child;
  final FoodModel foodModel;

  const FoodCard({
    required this.child,
    required this.foodModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () => showModalBottomSheet(
          enableDrag: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15)
            )
          ),
          builder: (context) => this.child
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                this.foodModel.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 18)
              ),
              Column(
                children: [
                  const Divider(color: Colors.black45, thickness: 2),
                  CardBody(food: this.foodModel),
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}

///CardBody components
class CardBody extends StatelessWidget {

  final FoodModel food;

  const CardBody({
    required this.food,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/food_types/${this.food.foodType.toString().split('.').last}.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(height: 60, image: AssetImage(imagePath)),
          Column(
            children: [
              const Text(
                'Calorías',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
              ),
              Text(
                '${this.food.calories}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 38, color: Colors.deepOrangeAccent)
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              macronutrientInfo(Colors.lightGreen, "Carbs", this.food.carbs),
              macronutrientInfo(Colors.lightBlue, "Proteins", this.food.proteins),
              macronutrientInfo(Colors.yellowAccent, "Fats", this.food.fats),
            ],
          )
        ],
      ),
    );
  }
  Widget macronutrientInfo(Color color, String label, double value){
    return Row(
      children: [
        Text('$label: '),
        Text(
          '$value',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: color)
        ),
      ],
    );
  }
}

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
    else
      if(_counter > 1)
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
            hint: Text("Meal time"),
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
              const Text("Porciones"),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Porciones"),
        Row(
          children: [
            button(this.remove, Icons.remove),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(this.counter.toString()),
            ),
            button(this.add, Icons.add)
          ],
        )
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
