// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:health/health.dart';

class HealthService {
  final HealthFactory health = HealthFactory();
  final _dataUpdateController = StreamController<void>.broadcast();

  Stream<void> get onDataUpdate => _dataUpdateController.stream;

  get dataUpdateController => _dataUpdateController;

  Future<int> getStepsInInterval(DateTime timeToTrack) async {
    DateTime endOfDay = DateTime(timeToTrack.year, timeToTrack.month, timeToTrack.day, 0, 0, 0);
    return await health.getTotalStepsInInterval(endOfDay, timeToTrack) ?? 0;
  }

  Future<int> getCaloriesBurnedInInterval(DateTime timeToTrack) async {
    try {
      DateTime endOfDay = DateTime(timeToTrack.year, timeToTrack.month, timeToTrack.day, 0, 0, 0);
      List<HealthDataPoint> healthDataList = await health.getHealthDataFromTypes(endOfDay, timeToTrack, [HealthDataType.ACTIVE_ENERGY_BURNED]);
      double totalCalories = 0;
      for (var data in healthDataList)
        totalCalories += double.parse(data.value.toJson()['numericValue']);
      return totalCalories.toInt();
    } catch (e) {
      return 0;
    }
  }

  void dispose() => _dataUpdateController.close();
}
