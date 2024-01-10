// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/day_model.dart';
import 'package:personal_nutrition_control/models/food_model.dart';
import 'package:personal_nutrition_control/providers/food_provider.dart';
import 'package:personal_nutrition_control/extensions/extensions.dart';
import 'package:personal_nutrition_control/utils/fortmatter.dart';
import 'package:personal_nutrition_control/widgets/calendar_widgets/calendar_picker.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/food_card.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/no_data.dart';
import 'package:provider/provider.dart';
import 'package:personal_nutrition_control/providers/day_provider.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';

import 'package:personal_nutrition_control/widgets/home_widgets/dashboard.dart';

class CalendarBody extends StatefulWidget {
  const CalendarBody({super.key});

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = DateTime.now();
    super.initState();
  }

  Future<void> onPressed(DayProvider dayProvider) async {
    DateTime now = DateTime.now();

    String? createdAt = Provider.of<UserProvider>(context, listen: false).user?.createdAt;

    DateTime firstDate = getFormattedDateTime(createdAt ?? '${now.year}-${now.month}-${now.day}');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate)
      setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DayProvider>(
      builder: (context, dayProvider, child){
        DayModel? selectedDay = dayProvider.getSpecificDay(selectedDate ?? DateTime.now());

        String day = getFormattedDay('${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}');

        return Column(
          children: [
            CalendarPicker(
              day: day,
              onPressed: () async => onPressed(dayProvider),
            ),
            if(selectedDay == null)
              const Expanded(
                child: NoData(label: "You have no consumption this day")
              )
            else
              Column(
                children: [
                  DiaryIndicators(dayToView: selectedDay),
                  MealTimeCard(dayToView: selectedDay)
                ]
              )
          ],
        );
      }
    );
  }
}

class MealTimeCard extends StatefulWidget {
  final DayModel? dayToView;

  const MealTimeCard({
    this.dayToView,
    super.key
  });

  @override
  State<MealTimeCard> createState() => _MealTimeCardState();
}

class _MealTimeCardState extends State<MealTimeCard> {

  final List<String> mealTypes = ['breakfast', 'lunch', 'snack', 'dinner', 'appetizer'];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.black26,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
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

                if(widget.dayToView == null)
                  return Container();

                Map<String, int>? mealFoods = widget.dayToView?.meals[mealTypes[index]];
                if (mealFoods == null)
                  return const NoData(label: "No consumiste nada en este horario");

                return ListView(
                  shrinkWrap: true,
                  children: mealFoods.entries.map((entry) {
                    String foodId = entry.key;
                    int portions = entry.value;

                    FoodModel? food = Provider.of<FoodProvider>(context, listen: false).getFood(foodId);
                    return food != null ? FoodCard(foodModel: food, portions: portions) : Container();
                  }).toList(),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}