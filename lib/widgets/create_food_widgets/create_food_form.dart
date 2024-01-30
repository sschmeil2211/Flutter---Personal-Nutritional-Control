// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/custom_buttons.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/input_field.dart';

class CreationFoodForm extends StatefulWidget {
  const CreationFoodForm({super.key});

  @override
  State<CreationFoodForm> createState() => _CreationFoodFormState();
}

class _CreationFoodFormState extends State<CreationFoodForm> {


  TextEditingController nameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController proteinsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  MeasureType? selectedMeasureType;
  FoodType? selectedFoodType;
  bool loading = false;

  Future<void> onPressed(FoodProvider foodProvider, String userID) async {
    String id = const Uuid().v4();
    FoodModel newFood = FoodModel(
        id: id,
        name: nameController.text,
        addedBy: userID,
        calories: double.parse(caloriesController.text),
        proteins: double.parse(proteinsController.text),
        carbs: double.parse(carbsController.text),
        fats: double.parse(fatsController.text),
        foodType: selectedFoodType ?? FoodType.other,
        measureType: selectedMeasureType ?? MeasureType.g
    );
    setState(() => loading = true);
    bool success = await foodProvider.addFood(id, newFood);
    if(!context.mounted) return;
    if(success)
      Navigator.pop(context);
    setState(() => loading = true);
  }

  @override
  Widget build(BuildContext context) {
    List<InputFieldsData> data = InputFieldsData.foodInputs(carbsController, proteinsController, fatsController);
    FoodProvider foodProvider = Provider.of<FoodProvider>(context, listen: false);
    String userID = Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SectionCard(
            title: 'Food Name',
            child: FoodInput(
              color: Colors.white,
              controller: nameController,
              isNumberInput: false,
            )
        ),
        FoodTypeGridSelector(
          color: (foodType) => selectedFoodType == foodType ? Colors.white24 : Colors.white10,
          onPressed: (foodType) => setState(() => selectedFoodType = foodType),
        ),
        SectionCard(
          title: 'Calories',
          child: FoodInput(
            color: Colors.deepOrangeAccent,
            controller: caloriesController,
          ),
        ),
        SectionCard(
          title: 'Macronutrients',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.map((d) => FoodInput(
                color: d.labelColor,
                label: d.label,
                controller: d.controller
            )).toList(),
          ),
        ),
        SectionCard(
          title: 'Measure Type',
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: width, maxWidth: width),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: MeasureType.values.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Text(formatEnumName(e).toLowerCase()),
                    color: selectedMeasureType == e ? Colors.white24 : Colors.white10,
                    onPressed: () => setState(() => selectedMeasureType = e),
                  ),
                )).toList()
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: ButtonWithLoading(
            isLoading: loading,
            label: 'Create Food',
            onPressed: () async => await onPressed(foodProvider, userID),
          ),
        )
      ],
    );
  }
}


class FoodTypeGridSelector extends StatelessWidget {
  final Color? Function(FoodType) color;
  final Function(FoodType) onPressed;

  const FoodTypeGridSelector({
    required this.color,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Food Type',
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        crossAxisCount: 3,
        childAspectRatio: 1.15,
        children: List.generate(FoodType.values.length, (index) {
          FoodType foodType = FoodType.values[index];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: MaterialButton(
                color: this.color(foodType),
                onPressed: () => this.onPressed(foodType),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(formatEnumName(foodType)),
                    ),
                    Image(height: 50, image: AssetImage(paths[index])),
                  ],
                ),
              )
          );
        }),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({
    required this.title,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width, minWidth: width),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  this.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            this.child
          ],
        ),
      ),
    );
  }
}
