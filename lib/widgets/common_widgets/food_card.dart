// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/models/models.dart';

class FoodCard extends StatelessWidget {
  final int? portions;
  final bool editable;
  final Widget? child;
  final FoodModel foodModel;

  const FoodCard({
    this.editable = false,
    this.child,
    required this.foodModel,
    this.portions,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: InkWell(
        onTap: editable ? () => showModalBottomSheet(
          enableDrag: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15)
            )
          ),
          builder: (context) => this.child == null ? Container() : this.child!
        ) : null,
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
                    Text('x${this.portions}')
                ],
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

    String foodCalories = this.food.calories % 1 == 0 ? this.food.calories.toInt().toString() : this.food.calories.toString();
    String foodCarbs = this.food.carbs % 1 == 0 ? this.food.carbs.toInt().toString() : this.food.carbs.toString();
    String foodProteins = this.food.proteins % 1 == 0 ? this.food.proteins.toInt().toString() : this.food.proteins.toString();
    String foodFats = this.food.fats % 1 == 0 ? this.food.fats.toInt().toString() : this.food.fats.toString();

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
                'Calories',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
              ),
              Text(
                foodCalories,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 38, color: Colors.deepOrangeAccent)
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              macronutrientInfo(Colors.lightGreen, "Carbs", foodCarbs),
              macronutrientInfo(Colors.lightBlue, "Proteins", foodProteins),
              macronutrientInfo(Colors.yellowAccent, "Fats", foodFats),
            ],
          )
        ],
      ),
    );
  }
  Widget macronutrientInfo(Color color, String label, String value){
    return Row(
      children: [
        Text('$label: '),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: color)
        ),
      ],
    );
  }
}
