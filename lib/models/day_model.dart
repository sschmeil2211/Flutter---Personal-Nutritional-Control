// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures
import 'package:cloud_firestore/cloud_firestore.dart';

class DayModel {
  final String id;
  final double caloriesConsumed;
  final double carbsConsumed;
  final double proteinsConsumed;
  final double fatsConsumed;
  final String date;
  final Map<String, Map<String, int>> meals;

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
    'id': id,
    'caloriesConsumed': this.caloriesConsumed,
    'carbsConsumed': this.carbsConsumed,
    'proteinsConsumed': this.proteinsConsumed,
    'date': this.date,
    'fatsConsumed': this.fatsConsumed,
    'meals': this.meals,
  };

  factory DayModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    Map<String, Map<String, int>> mealsMap = {};
    if (data?['meals'] != null)
      data?['meals'].forEach((key, value) {
        if (value is Map<String, dynamic>)
          mealsMap[key] = Map<String, int>.from(value);
      });

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
    Map<String, Map<String, int>>? meals,
  }) => DayModel(
    id: this.id,
    caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
    carbsConsumed: carbsConsumed ?? this.carbsConsumed,
    proteinsConsumed: proteinsConsumed ?? this.proteinsConsumed,
    fatsConsumed: fatsConsumed ?? this.fatsConsumed,
    date: date ?? this.date,
    meals: meals ?? Map<String, Map<String, int>>.from(this.meals),
  );
}