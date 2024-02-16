// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

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
    DateTime firstDate = stringToDateTime(createdAt ?? '${now.year}-${now.month}-${now.day}');
    DateTime? picked = await showDatePicker(
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
        String day = getFormattedDateTime(selectedDate ?? DateTime.now());

        return Column(
          children: [
            MaterialButton(
              elevation: 0,
              onPressed: () => onPressed(dayProvider),
              child: Text(
                day,
                style: const TextStyle(fontSize: 20),
              )
            ),
            selectedDay == null
                ? const Expanded(
                    child: NoData(label: "You have no consumption this day")
                  )
                : Column(
                    children: [
                      FoodDashboard(dayToView: selectedDay),
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

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      color: Colors.black26,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              formatEnumName(MealTime.values[currentPage]),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: MealTime.values.length,
              controller: PageController(viewportFraction: 1),
              onPageChanged: (int page) => setState(() => currentPage = page),
              itemBuilder: (context, index) {

                if(widget.dayToView == null)
                  return Container();

                Map<String, double>? mealFoods = widget.dayToView?.meals[MealTime.values[index]];
                if (mealFoods == null)
                  return const NoData(label: "You didn't consume anything during this time.");

                return ListView(
                  shrinkWrap: true,
                  children: mealFoods.entries.map((entry) {
                    String foodId = entry.key;
                    double portions = entry.value;

                    FoodModel? food = Provider.of<FoodProvider>(context, listen: false).getFood(foodId);
                    return food == null
                        ? Container()
                        : FoodCard(foodModel: food, portions: portions);
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