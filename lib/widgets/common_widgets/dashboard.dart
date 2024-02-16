// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';

class FoodDashboard extends StatelessWidget {
  final DayModel dayToView;

  const FoodDashboard({
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
      child: Column(
        children: [
          Row(
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
              ),
            ],
          ),
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
            color: value > 1 ? Colors.red : Colors.deepOrangeAccent,
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
    double carbs = this.totalCarbs / totalMacros;
    double proteins = this.totalProteins / totalMacros;
    double fats = this.totalFats / totalMacros;

    List<MacronutrientsData> macronutrients = MacronutrientsData.data(carbs, proteins, fats);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1), // Ajusta según la velocidad deseada
      builder: (context, double value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: macronutrients.map((m) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                m.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              LinearProgressIndicator(
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.white12,
                value: m.value,
                color: m.color,
              ),
            ],
          ),
        )).toList(),
      )
    );
  }
}

class HealthIndicators extends StatefulWidget {
  final DateTime timeToTrack;

  const HealthIndicators({
    required this.timeToTrack,
    super.key
  });

  @override
  State<HealthIndicators> createState() => _HealthIndicatorsState();
}

class _HealthIndicatorsState extends State<HealthIndicators> {
  @override
  void dispose() {
    Provider.of<HealthProvider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, health, child){
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              indicator(FontAwesomeIcons.shoePrints, '${health.steps}'),
              indicator(FontAwesomeIcons.fire, '${health.caloriesBurned}'),
            ],
          ),
        );
      }
    );
  }

  Widget indicator(IconData icon, String label){
    return Row(
      children: [
        Icon(icon, size: 18),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
