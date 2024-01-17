// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class AddTodayFood extends StatefulWidget {
  const AddTodayFood({super.key});

  @override
  State<AddTodayFood> createState() => _AddTodayFoodState();
}

class _AddTodayFoodState extends State<AddTodayFood>{

  bool changedWidget = false;

  FoodType selectedFoodType = FoodType.other; // Agrega la variable para el tipo seleccionado

  void _toggleChange() => setState(() => changedWidget = !changedWidget );
  void _filterFoodsByType(FoodType foodType) => setState(() {
    selectedFoodType = foodType;
    _toggleChange();
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.black26,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchAnimation(
        isPressed: changedWidget,
        originalWidget: FoodTypeGrid(paths: paths, onPressed: _filterFoodsByType),
        newWidget: FoodList(onPressReturnIcon: _toggleChange, selectedFoodType: selectedFoodType)
      ),
    );
  }
}

class FoodTypeGrid extends StatelessWidget {

  final Function(FoodType) onPressed;
  final List<String> paths;

  const FoodTypeGrid({
    required this.onPressed,
    required this.paths,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: const Text("Add to today's meal"),
        ),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          crossAxisCount: 3,
          childAspectRatio: 1.3,
          children: List.generate(10, (index) {

            final FoodType foodType = FoodType.values[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: MaterialButton(
                color: Colors.white10,
                onPressed: () => this.onPressed(foodType),
                child: Image(height: 50, image: AssetImage(paths[index])),
              )
            );
          }),
        ),
      ],
    );
  }
}

class FoodList extends StatelessWidget {

  final Function() onPressReturnIcon;
  final FoodType selectedFoodType;

  const FoodList({
    required this.onPressReturnIcon,
    required this.selectedFoodType,
    super.key
  });

  Future<void> onPressed(BuildContext context, String mealType, FoodModel food, int portions) async {
    DayProvider dayProvider = Provider.of<DayProvider>(context, listen: false);
    await dayProvider.handleDay(mealType, food, portions);
    portions = 1;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int portions = 1;
    String mealType = 'appetizer';

    FoodProvider foodProvider = Provider.of<FoodProvider>(context, listen: false);
    List<FoodModel> filteredFoods = foodProvider.getFoodsByType(this.selectedFoodType);

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: IconButton(
            onPressed: this.onPressReturnIcon,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        if(filteredFoods.isEmpty)
          NoData(label: 'No food found')
        else
          Column(
            children: List.generate(filteredFoods.length, (index) {
              FoodModel food = filteredFoods[index];

              return FoodCard(
                editable: true,
                foodModel: food,
                child: FoodCardModal(
                  buttonLabel: "Save",
                  onChangeMealTime: (value) => mealType = value,
                  onCounterChanged: (value) => portions = value,
                  onPressed: () => onPressed(context, mealType, food, portions),
                ),
              );
            }),
          )
      ],
    );
  }
}