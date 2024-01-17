import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:personal_nutrition_control/models/models.dart';

class FoodRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFood(FoodModel food) async => await _firestore.collection('foods').doc(food.id).set(food.toJson());

  Future<List<FoodModel>> getFoods() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('foods').get();
    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => FoodModel.fromSnapshot(doc)).toList();
  }

  Future<void> updateFood(FoodModel food) async => await _firestore.collection('foods').doc(food.id).update(food.toJson());

  Future<void> deleteFood(String foodId) async => await _firestore.collection('foods').doc(foodId).delete();
}