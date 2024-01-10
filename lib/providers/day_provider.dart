import 'package:flutter/foundation.dart';
import 'package:personal_nutrition_control/models/day_model.dart';
import 'package:personal_nutrition_control/models/food_model.dart';
import 'package:personal_nutrition_control/repositories/day_repository.dart';
import 'package:personal_nutrition_control/services/auth_service.dart';
import 'package:personal_nutrition_control/utils/fortmatter.dart';
import 'package:uuid/uuid.dart';

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
        DateTime dateTime = getFormattedDateTime(day.date);
        return dateTime.year == selectedDate.year
            && dateTime.month == selectedDate.month
            && dateTime.day == selectedDate.day;
      });
    } catch(e) {
      return null;
    }
  }

  Future<void> updateDay(DayModel day, FoodModel food, int portions) async {
    DayModel updatedDay = day.copyFrom(
      caloriesConsumed: day.caloriesConsumed + (portions * food.calories),
      carbsConsumed: day.carbsConsumed + (portions * food.carbs),
      proteinsConsumed: day.proteinsConsumed + (portions * food.proteins),
      fatsConsumed: day.fatsConsumed + (portions * food.fats)
    );
    await _dayRepository.updateDay(userID, updatedDay);
    notifyListeners();
  }

  Future<void> handleDay(String mealType, FoodModel food, int portions) async {
    DateTime now = DateTime.now();
    DayModel? day = await _dayRepository.getSpecificDay(userID, '${now.year}-${now.month}-${now.day}');//_actualDay;
    Map<String, int> mealMap = day?.meals[mealType] ?? {};

    mealMap.containsKey(food.id) ? mealMap[food.id] = (mealMap[food.id] ?? 0) + portions : mealMap[food.id] = portions;

    // Actualiza el modelo DayModel
    if(day != null){
      DayModel updatedDay = day.copyFrom(
        meals: {...day.meals, mealType: mealMap},
      );
      // Actualiza el modelo en el proveedor
      await updateDay(updatedDay, food, portions);
    }
    else{
      day = DayModel(
        id: const Uuid().v4(),
        caloriesConsumed: portions * food.calories,
        carbsConsumed: portions * food.carbs,
        proteinsConsumed: portions * food.proteins,
        fatsConsumed: portions * food.fats,
        date: '${now.year}-${now.month}-${now.day}',
        meals: {mealType: mealMap},
      );
      await addDay(day);
      _actualDay = day;
    }
  }
}