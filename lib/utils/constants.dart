import 'package:personal_nutrition_control/models/models.dart';

String getImagePath(FoodType foodType) => 'assets/images/food_types/${foodType.toString().split('.').last}.png';