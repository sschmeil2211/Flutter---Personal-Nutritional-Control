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

///Food Types grid
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
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 20),
          child: const Text("Add to today's meal"),
        ),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          crossAxisCount: 3,
          childAspectRatio: 1.3,
          mainAxisSpacing: 10,
          children: List.generate(10, (index) {
            final FoodType foodType = FoodType.values[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
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

///Foods List
class FoodList extends StatelessWidget {

  final Function() onPressReturnIcon;
  final FoodType selectedFoodType;

  const FoodList({
    required this.onPressReturnIcon,
    required this.selectedFoodType,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    int portions = 1;
    String mealType = 'appetizer';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: IconButton(
            onPressed: this.onPressReturnIcon,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        Consumer<FoodProvider>(
          builder: (context, foodProvider, child){

            List<FoodModel> filteredFoods = foodProvider.getFoodsByType(this.selectedFoodType);
            if(filteredFoods.isEmpty)
              return Container();

            return Column(
              children: List.generate(filteredFoods.length, (index) {
                DayProvider dayProvider = Provider.of<DayProvider>(context, listen: false);
                FoodModel food = filteredFoods[index];

                return FoodCard(
                  editable: true,
                  foodModel: food,
                  child: FoodCardModal(
                    buttonLabel: "Guardar",
                    onChangeMealTime: (value) => mealType = value,
                    onCounterChanged: (value) => portions = value,
                    onPressed: () async {
                      await dayProvider.handleDay(mealType, food, portions);
                      portions = 1;
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}