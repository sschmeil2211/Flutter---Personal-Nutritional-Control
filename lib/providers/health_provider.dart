import 'package:flutter/foundation.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/health_repository.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';
import 'package:personal_nutrition_control/services/services.dart';

class HealthProvider with ChangeNotifier {
  final HealthService _healthService = HealthService();
  final HealthRepository _healthRepository = HealthRepository();
  int? _steps;
  int? _caloriesBurned;

  HealthProvider() {
    init();
  }

  int get steps => _steps ?? 0;
  int get caloriesBurned => _caloriesBurned ?? 0;

  Future<void> init() async {
    DateTime now = DateTime.now();
    DateTime lastMidnight = DateTime(now.year, now.month, now.day, 23, 59, 59).subtract(const Duration(days: 1));
    await createHealthDocument(AuthService().currentUser!.uid, lastMidnight);
    // Obtener los datos actuales del día
    _steps = await _healthService.getStepsInInterval(now);
    _caloriesBurned = await _healthService.getCaloriesBurnedInInterval(now);
    notifyListeners();
  }

  Future<void> createHealthDocument(String userId, DateTime date) async {
    HealthModel? existingHealth = await _healthRepository.getSpecificHealth(userId, date);
    if(existingHealth != null) return;
    HealthModel healthData = HealthModel(
      burnedCalories: await _healthService.getCaloriesBurnedInInterval(date),
      steps: await _healthService.getStepsInInterval(date),
      date: date
    );
    String docId = '${date.year}-${date.month}-${date.day}';
    await _healthRepository.addHealth(userId,  docId, healthData);
  }
}