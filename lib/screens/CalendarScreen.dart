// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/DayModel.dart';
import 'package:personal_nutrition_control/models/FoodModel.dart';
import 'package:personal_nutrition_control/providers/DayProvider.dart';
import 'package:personal_nutrition_control/providers/FoodProvider.dart';
import 'package:personal_nutrition_control/utils/Extensions.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/FoodCardWidgets.dart';

import 'package:personal_nutrition_control/widgets/home_widgets/DashboardsWidgets.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            DiaryIndicators(),
            MealTimeCard()
          ],
        ),
      ),
    );
  }
}

class MealTimeCard extends StatefulWidget {

  const MealTimeCard({super.key});

  @override
  State<MealTimeCard> createState() => _MealTimeCardState();
}

class _MealTimeCardState extends State<MealTimeCard> {

  final List<String> mealTypes = ['breakfast', 'lunch', 'snack', 'dinner', 'appetizer'];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: Colors.black26,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Consumer<DayProvider>(
        builder: (context, dayProvider, child){

          DayModel? actualDay = dayProvider.actualDay;
          if(actualDay == null)
            return Container();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  mealTypes[currentPage].capitalize(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mealTypes.length,
                  controller: PageController(viewportFraction: 1),
                  onPageChanged: (int page) => setState(() => currentPage = page),
                  itemBuilder: (context, index) {

                    List<DayModel?>? days = dayProvider.days;
                    Map<String, int>? mealFoods = days.first?.meals[mealTypes[index]];

                    if (mealFoods == null)
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report_problem_outlined, color: Colors.white24, size: 50),
                          Text("No consumiste nada en este horario", style: TextStyle(color: Colors.white24))
                        ],
                      );

                    return ListView(
                      shrinkWrap: true,
                      children: mealFoods.entries.map((entry) {
                        String foodId = entry.key;
                        int portions = entry.value;

                        FoodModel? food = Provider.of<FoodProvider>(context, listen: false).getFood(foodId);

                        return food != null ? FoodInfoDashboard(foodModel: food, portions: portions) : Container();
                      }).toList(),
                    );
                    /*return StreamBuilder<List<DayModel?>>(
                      stream: dayProvider.getDaysStream,
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return const CircularProgressIndicator();
                        else if (snapshot.hasError)
                          return Container();

                        List<DayModel?>? days = snapshot.data;
                        Map<String, int>? mealFoods = days?.first?.meals[mealTypes[index]];
                        if (mealFoods == null || days == null)
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.report_problem_outlined, color: Colors.white24, size: 50),
                              Text("No consumiste nada en este horario", style: TextStyle(color: Colors.white24))
                            ],
                          );

                        return ListView(
                          shrinkWrap: true,
                          children: mealFoods.entries.map((entry) {
                            String foodId = entry.key;
                            int portions = entry.value;

                            FoodModel? food = Provider.of<FoodProvider>(context, listen: false).getFood(foodId);

                            return food != null ? FoodInfoDashboard(foodModel: food, portions: portions) : Container();
                          }).toList(),
                        );
                      }
                    );*/
                  },
                ),
              ),
            ],
          );
        }
      )
    );
  }
}

class FoodInfoDashboard extends StatelessWidget {

  final int portions;
  final FoodModel foodModel;

  const FoodInfoDashboard({
    required this.portions,
    required this.foodModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.foodModel.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 18)
                  ),
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
    );
  }
}