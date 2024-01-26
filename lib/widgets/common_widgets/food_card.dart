// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/utils/constants.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

class FoodCard extends StatelessWidget {
  final double? portions;
  final FoodModel foodModel;
  final Function()? onTap;

  const FoodCard({
    required this.foodModel,
    this.onTap,
    this.portions,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    String measureType = formatEnumName(this.foodModel.measureType).toLowerCase();
    return Card(
      margin: const EdgeInsets.all(15),
      child: InkWell(
        onTap: this.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: this.portions == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.foodModel.name,
                    style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 18)
                  ),
                  if(this.portions != null)
                    Text('x ${this.portions?.toInt()}$measureType')
                ],
              ),
              const Divider(color: Colors.black45, thickness: 2),
              Column(
                children: [
                  CardBody(food: this.foodModel),
                  Align(
                    alignment: Alignment.centerRight,
                    child:Text(
                      'Every 100$measureType',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    )
                  )
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}

class CardBody extends StatelessWidget {
  final FoodModel food;

  const CardBody({
    required this.food,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<MacronutrientsData> macronutrients = MacronutrientsData.data(this.food.carbs, this.food.proteins, this.food.fats);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(
            height: 60, 
            image: AssetImage(getImagePath(this.food.foodType))
          ),
          CaloriesInfo(calories: this.food.calories),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: macronutrients.map((e) => MacronutrientInfo(
              macronutrient: e.label,
              amount: e.value,
              color: e.color,
            )).toList(),
          )
        ],
      ),
    );
  }
}

class CaloriesInfo extends StatelessWidget {
  final double calories;

  const CaloriesInfo({
    required this.calories,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    String foodCalories = this.calories % 1 == 0 ? this.calories.toInt().toString() : this.calories.toString();
    return Column(
      children: [
        const Text(
          'Calories',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
        ),
        Text(
          foodCalories,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 38, color: Colors.deepOrangeAccent)
        ),
      ],
    );
  }
}

class MacronutrientInfo extends StatelessWidget {
  final double amount;
  final String macronutrient;
  final Color color;

  const MacronutrientInfo({
    required this.color,
    required this.amount,
    required this.macronutrient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String value = amount % 1 == 0 ? amount.toInt().toString() : amount.toString();
    return Row(
      children: [
        Text('$macronutrient: '),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: color)
        ),
      ],
    );
  }
}
