// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

class FoodModel {
  final String id;
  final String name;
  final String addedBy;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final FoodType foodType;
  final MeasureType measureType;

  const FoodModel({
    required this.id,
    required this.name,
    required this.addedBy,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.foodType,
    required this.measureType,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': this.name,
    'addedBy': this.addedBy,
    'foodType': this.foodType.toString(),
    'calories': this.calories,
    'proteins': this.proteins,
    'carbs': this.carbs,
    'fats': this.fats,
    'measureType': this.measureType
  };

  factory FoodModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    return FoodModel(
      id: data?['id'],
      name: data?['name'],
      addedBy: data?['addedBy'],
      calories: (data?['calories'] as num).toDouble(),  // Conversión explícita a double
      proteins: (data?['proteins'] as num).toDouble(),
      carbs: (data?['carbs'] as num).toDouble(),
      fats: (data?['fats'] as num).toDouble(),
      foodType: getFoodType(data?['foodType']),
      measureType: getMeasureType(data?['measureType'])
    );
  }
}

enum FoodType {
  dairy,
  drink,
  fruit,
  grain,
  legume,
  meat,
  nut,
  processed,
  sweet,
  vegetable,
  other
}

enum MeasureType{
  ml,
  g
}