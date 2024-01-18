// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';

class DiaryIndicators extends StatelessWidget {
  final DayModel dayToView;

  const DiaryIndicators({
    required this.dayToView,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    double targetCalories = Provider.of<UserProvider>(context, listen: false).user?.targetCalories ?? 2000;
    double caloriesConsumed = dayToView.caloriesConsumed;
    double actualValue = dayToView.caloriesConsumed / targetCalories;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size * 0.15, minWidth: size * 0.15,
              maxHeight: size * 0.15, minHeight: size * 0.15,
            ),
            child: CaloriesIndicator(
              actualValue: caloriesConsumed,
              actualValuePercent: actualValue,
              totalCalories: targetCalories,
            )
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size * 0.15, minWidth: size * 0.15,
              maxHeight: size * 0.15, minHeight: size * 0.15,
            ),
            child: MacronutrientsIndicator(
              totalProteins: dayToView.proteinsConsumed,
              totalCarbs: dayToView.carbsConsumed,
              totalFats: dayToView.fatsConsumed,
            ),
          )
        ],
      ),
    );
  }
}

class CaloriesIndicator extends StatelessWidget {
  final double actualValuePercent;
  final double actualValue;
  final double totalCalories;

  const CaloriesIndicator({
    required this.totalCalories,
    required this.actualValue,
    required this.actualValuePercent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${this.actualValue.toInt()} / ${this.totalCalories.toInt()}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child:Text(
                'kCal',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: actualValuePercent),
          duration: const Duration(seconds: 1), // Ajusta según la velocidad deseada
          builder: (context, double value, child) => CircularProgressIndicator(
            value: value,
            backgroundColor: Colors.white12,
            color: value > 1 ? Colors.red : Colors.orange,
            strokeWidth: 10,
            strokeCap: StrokeCap.round,
          )
        ),
      ],
    );
  }
}

class MacronutrientsIndicator extends StatelessWidget {

  final double totalProteins;
  final double totalFats;
  final double totalCarbs;

  const MacronutrientsIndicator({
    required this.totalProteins,
    required this.totalFats,
    required this.totalCarbs,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    double totalMacros = totalProteins + totalCarbs + totalFats;

    double proteinsPercentage = this.totalProteins / totalMacros;
    double carbsPercentage = this.totalCarbs / totalMacros;
    double fatsPercentage = this.totalFats / totalMacros;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1), // Ajusta según la velocidad deseada
      builder: (context, double value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          macroPercentageIndicator(carbsPercentage, 'Carbs', Colors.yellowAccent),
          macroPercentageIndicator(proteinsPercentage, 'Proteins', Colors.lightBlue),
          macroPercentageIndicator(fatsPercentage, 'Fats', Colors.lightGreen),
        ],
      )
    );
  }
  Widget macroPercentageIndicator(double value, String label, Color color){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          LinearProgressIndicator(
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.white12,
            value: value,
            color: color,
          ),
        ],
      ),
    );
  }
}