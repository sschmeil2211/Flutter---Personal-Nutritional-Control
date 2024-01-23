import 'package:flutter/foundation.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';

class FoodProvider with ChangeNotifier {
  final FoodRepository _foodRepository = FoodRepository();
  List<FoodModel> _foods = [];

  List<FoodModel> get foods => _foods;

  FoodProvider(){
    loadFoods();
  }

  Future<void> addFood(FoodModel food) async {
    await _foodRepository.addFood(food);
    _foods.add(food);
    notifyListeners();
  }

  Future<void> loadFoods() async {
    _foods = await _foodRepository.getFoods();
    notifyListeners();
  }

  Future<void> updateFood(FoodModel food) async {
    await _foodRepository.updateFood(food);
    _foods = await _foodRepository.getFoods();
    notifyListeners();
  }

  Future<void> deleteFood(String foodId) async {
    await _foodRepository.deleteFood(foodId);
    _foods = await _foodRepository.getFoods();
    notifyListeners();
  }

  FoodModel? getFood(String foodID) {
    try{
      return _foods.firstWhere((food) => food.id.contains(foodID));
    } catch(e) {
      return null;
    }
  }

  List<FoodModel> filterFoodsByName(String name) => _foods
      .where((food) => food.name.toLowerCase().contains(name.toLowerCase())).toList();

  List<FoodModel> getFoodsByType(FoodType foodType) => _foods.where((e) => e.foodType == foodType).toList();
}