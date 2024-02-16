// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures
import 'package:cloud_firestore/cloud_firestore.dart';

class DayModel {
  final String id;
  final double caloriesConsumed;
  final double carbsConsumed;
  final double proteinsConsumed;
  final double fatsConsumed;
  final String date;
  final Map<MealTime, Map<String, double>> meals;

  const DayModel({
    required this.id,
    required this.caloriesConsumed,
    required this.carbsConsumed,
    required this.proteinsConsumed,
    required this.fatsConsumed,
    required this.date,
    required this.meals
  });

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'caloriesConsumed': this.caloriesConsumed,
    'carbsConsumed': this.carbsConsumed,
    'proteinsConsumed': this.proteinsConsumed,
    'date': this.date,
    'fatsConsumed': this.fatsConsumed,
    'meals': convertMealsToJson(),
  };

  factory DayModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    Map<MealTime, Map<String, double>> mealsMap = convertMealsFromJson(data?['meals']);

    return DayModel(
      id: data?['id'],
      caloriesConsumed: (data?['caloriesConsumed'] as num).toDouble(),
      carbsConsumed: (data?['carbsConsumed'] as num).toDouble(),
      proteinsConsumed: (data?['proteinsConsumed'] as num).toDouble(),
      fatsConsumed: (data?['fatsConsumed'] as num).toDouble(),
      date: data?['date'] ?? "",
      meals: mealsMap,
    );
  }

  DayModel copyFrom({
    double? caloriesConsumed,
    double? carbsConsumed,
    double? proteinsConsumed,
    double? fatsConsumed,
    String? date,
    Map<MealTime, Map<String, double>>? meals,
  }) => DayModel(
    id: this.id,
    caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
    carbsConsumed: carbsConsumed ?? this.carbsConsumed,
    proteinsConsumed: proteinsConsumed ?? this.proteinsConsumed,
    fatsConsumed: fatsConsumed ?? this.fatsConsumed,
    date: date ?? this.date,
    meals: meals ?? Map<MealTime, Map<String, double>>.from(this.meals),
  );

  static Map<MealTime, Map<String, double>> convertMealsFromJson(Map<String, dynamic>? mealsData) {
    Map<MealTime, Map<String, double>> mealsMap = {};
    if (mealsData != null) {
      mealsData.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          MealTime mealTime = MealTime.values.firstWhere((time) => time.toString() == key, orElse: () => MealTime.appetizer);
          mealsMap[mealTime] = Map<String, double>.from(value);
        }
      });
    }
    return mealsMap;
  }

  Map<String, dynamic> convertMealsToJson() {
    Map<String, dynamic> mealsMap = {};
    meals.forEach((time, value) => mealsMap[time.toString()] = value);
    return mealsMap;
  }
}

enum MealTime{
  breakfast,
  lunch,
  snack,
  dinner,
  appetizer
}

/*

  factory DayModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    Map<MealTime, Map<String, double>> mealsMap =
        _convertMealsFromJson(data?['meals']);

    return DayModel(
      id: data?['id'],
      caloriesConsumed: (data?['caloriesConsumed'] as num).toDouble(),
      carbsConsumed: (data?['carbsConsumed'] as num).toDouble(),
      proteinsConsumed: (data?['proteinsConsumed'] as num).toDouble(),
      fatsConsumed: (data?['fatsConsumed'] as num).toDouble(),
      date: data?['date'] ?? "",
      meals: mealsMap,
    );
  }
}
* */