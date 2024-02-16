// ignore_for_file: unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

class HealthModel {
  final int steps;
  final int burnedCalories;
  final DateTime date;

  HealthModel({
    required this.steps,
    required this.date,
    required this.burnedCalories,
  });

  Map<String, dynamic> toJson() => {
    'steps': this.steps,
    'date': '${this.date.year}-${this.date.month}-${this.date.day}',
    'burnedCalories': this.burnedCalories,
  };

  factory HealthModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();

    return HealthModel(
      steps: data?['steps'],
      date: stringToDateTime(data?['date']),
      burnedCalories: (data?['burnedCalories'] as num).toInt()
    );
  }

  HealthModel copyFrom({
    int? steps,
    int? burnedCalories,
    DateTime? date,
  }) => HealthModel(
    date: date ?? this.date,
    burnedCalories: burnedCalories ?? this.burnedCalories,
    steps: steps ?? this.steps,
  );
}