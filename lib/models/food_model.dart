// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/utils/enum_utils.dart';

class FoodModel {
  final String id;
  final String name;
  final FoodType foodType;
  final String addedBy;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;

  const FoodModel({
    required this.id,
    required this.name,
    required this.foodType,
    required this.addedBy,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
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
  };

  factory FoodModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    return FoodModel(
      id: data?['id'],
      name: data?['name'],
      addedBy: data?['addedBy'],
      foodType: getFoodType(data?['foodType']),
      calories: data?['calories'],
      proteins: data?['proteins'],
      carbs: data?['carbs'],
      fats: data?['fats'],
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