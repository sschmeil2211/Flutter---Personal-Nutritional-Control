// ignore_for_file: curly_braces_in_flow_control_structures

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
  List<HealthModel>? _healths;
  HealthModel? _today;

  HealthProvider() {
    init();
  }

  int get steps => _steps ?? 0;
  int get caloriesBurned => _caloriesBurned ?? 0;
  List<HealthModel> get healths => _healths ?? [];
  HealthModel? get today => _today;


  set caloriesBurned(int value) {
    _caloriesBurned = value;
    notifyListeners();
  }

  Future<void> init() async {
    DateTime now = DateTime.now();
    _steps = await _healthService.getStepsInInterval(now);
    await getToday();
    _healthRepository.getHealthStream(AuthService().currentUser?.uid ?? '').listen((healths) => _healths = healths);
    await handleLastHealth(now);
    notifyListeners();
  }

  Future<void> handleLastHealth(DateTime now) async{
    DateTime lastMidnight = DateTime(now.year, now.month, now.day, 23, 59, 59).subtract(const Duration(days: 1));
    if (lastMidnight.isAfter(DateTime.now())) return;
    HealthModel? existingHealth = await _healthRepository.getSpecificHealth(AuthService().currentUser?.uid ?? '', lastMidnight);
    existingHealth == null
        ? await createHealth(lastMidnight, 0)
        : await updateHealth(lastMidnight, existingHealth.burnedCalories);
    notifyListeners();
  }

  Future<void> getToday() async {
    _today = await _healthRepository.getSpecificHealth(AuthService().currentUser?.uid ?? '', DateTime.now());
    _caloriesBurned = _today?.burnedCalories ?? 0;
    notifyListeners();
  }

  Future<void> createHealth(DateTime date, int burnedCalories) async {
    String? userID = AuthService().currentUser?.uid;
    if(userID == null) return;
    HealthModel healthData = HealthModel(
      burnedCalories: burnedCalories,
      steps: await _healthService.getStepsInInterval(date),
      date: date,
      lastUpdate: DateTime.now(),
    );
    String docId = '${date.year}-${date.month}-${date.day}';
    await _healthRepository.addHealth(userID,  docId, healthData);
    notifyListeners();
  }

  Future<void> updateHealth(DateTime date, int burnedCalories) async {
    String? userID = AuthService().currentUser?.uid;
    if(userID == null) return;
    HealthModel healthData = HealthModel(
      burnedCalories: burnedCalories,
      steps: await _healthService.getStepsInInterval(date),
      date: date,
      lastUpdate: DateTime.now(),
    );
    String docId = '${date.year}-${date.month}-${date.day}';
    await _healthRepository.updateHealth(userID, docId, healthData);
    notifyListeners();
  }
}