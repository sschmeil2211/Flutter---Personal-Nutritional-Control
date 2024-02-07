import 'package:flutter/foundation.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';

class HealthProvider extends ChangeNotifier {
  final HealthRepository _healthRepository = HealthRepository();

  int _stepsModel = 0;
  int _calories = 0;

  int get stepsModel => _stepsModel;
  int get calories => _calories;

  Future<void> getStepsData(DateTime timeToTrack) async {
    _stepsModel = await _healthRepository.getTotalStepsToday(timeToTrack);
    notifyListeners();
  }

  Future<void> getCaloriesData(DateTime timeToTrack) async {
    _calories = await _healthRepository.getCaloriesConsumed(timeToTrack);
    notifyListeners();
  }
}