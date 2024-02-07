// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:health/health.dart';

import 'package:personal_nutrition_control/models/models.dart';

class HealthRepository {
  final health = HealthFactory();

  Future<int> getTotalStepsToday(DateTime timeToTrack) async {
    //bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    // if (requested) {
      DateTime startOfDay = DateTime(timeToTrack.year, timeToTrack.month, timeToTrack.day, 0, 0, 0);
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startOfDay, timeToTrack, [HealthDataType.STEPS]);
      int totalSteps = 0;
      for (HealthDataPoint dataPoint in healthData)
        totalSteps += int.parse(dataPoint.value.toJson()['numericValue']);
      return totalSteps;
    //}

    // Manejar caso en el que la autorización fue rechazada
    //return 0;
  }

  Future<int> getCaloriesConsumed(DateTime timeToTrack) async {
    //bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    // if (requested) {
    DateTime startOfDay = DateTime(timeToTrack.year, timeToTrack.month, timeToTrack.day, 0, 0, 0);
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startOfDay, timeToTrack, [HealthDataType.ACTIVE_ENERGY_BURNED]);
    int totalSteps = 0;
    for (HealthDataPoint dataPoint in healthData)
      totalSteps += double.parse(dataPoint.value.toJson()['numericValue']).toInt();
     return totalSteps;
    //}

    // Manejar caso en el que la autorización fue rechazada
    //return 0;
  }
}