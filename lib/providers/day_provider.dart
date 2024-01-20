import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';
import 'package:personal_nutrition_control/services/auth_service.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

class DayProvider with ChangeNotifier {
  final DayRepository _dayRepository = DayRepository();
  List<DayModel?> _days = [];
  DayModel? _actualDay;

  List<DayModel?> get days => _days;
  DayModel? get actualDay => _actualDay;
  String userID = AuthService().currentUser?.uid ?? '';

  DayProvider(){
    getDays();
    getToday();
  }

  Future<void> addDay(DayModel day) async {
    await _dayRepository.addDay(userID, day);
    _days.add(day);
    notifyListeners();
  }

  Future<void> getDays() async {
    _dayRepository.getDaysStream(userID).listen((days) => _days = days);
    notifyListeners();
  }

  Future<void> getToday() async{
    try{
      DateTime now = DateTime.now();
      _actualDay = await _dayRepository.getSpecificDay(userID, '${now.year}-${now.month}-${now.day}');
      notifyListeners();
    }catch(e){
      return;
    }
  }

  DayModel? getSpecificDay(DateTime selectedDate){
    try{
      return _days.firstWhere((day) {
        if(day == null) return false;
        DateTime dateTime = stringToDateTime(day.date);
        return dateTime.year == selectedDate.year
            && dateTime.month == selectedDate.month
            && dateTime.day == selectedDate.day;
      });
    } catch(e) {
      return null;
    }
  }

  Future<void> updateDay(DayModel day, FoodModel food, double portions) async {
    DayModel updatedDay = day.copyFrom(
      caloriesConsumed: day.caloriesConsumed + (portions * food.calories / 100),
      carbsConsumed: day.carbsConsumed + (portions * food.carbs / 100),
      proteinsConsumed: day.proteinsConsumed + (portions * food.proteins / 100),
      fatsConsumed: day.fatsConsumed + (portions * food.fats / 100)
    );
    await _dayRepository.updateDay(userID, updatedDay);
    notifyListeners();
  }

  Future<void> handleDay(MealTime mealTime, FoodModel food, double portions) async {
    DateTime now = DateTime.now();
    DayModel? day = await _dayRepository.getSpecificDay(userID, '${now.year}-${now.month}-${now.day}');
    Map<String, double> mealMap = day?.meals[mealTime.toString()] ?? {};

    mealMap.containsKey(food.id) ? mealMap[food.id] = (mealMap[food.id] ?? 0) + portions : mealMap[food.id] = portions;

    // Actualiza el modelo DayModel
    if(day != null){
      DayModel updatedDay = day.copyFrom(
        meals: {...day.meals, mealTime: mealMap},
      );
      // Actualiza el modelo en el proveedor
      await updateDay(updatedDay, food, portions);
    }
    else{
      day = DayModel(
        id: const Uuid().v4(),
        caloriesConsumed: portions * food.calories / 100,
        carbsConsumed: portions * food.carbs / 100,
        proteinsConsumed: portions * food.proteins / 100,
        fatsConsumed: portions * food.fats / 100,
        date: '${now.year}-${now.month}-${now.day}',
        meals: {mealTime: mealMap},
      );
      await addDay(day);
      _actualDay = day;
    }
  }
}