// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:health/health.dart';

class HealthService {
  final HealthFactory health = HealthFactory();
  final _dataUpdateController = StreamController<void>.broadcast();

  Stream<void> get onDataUpdate => _dataUpdateController.stream;

  StreamController<void> get dataUpdateController => _dataUpdateController;

  Future<int> getStepsInInterval(DateTime timeToTrack) async {
    DateTime endOfDay = DateTime(timeToTrack.year, timeToTrack.month, timeToTrack.day, 0, 0, 0);
    return await health.getTotalStepsInInterval(endOfDay, timeToTrack) ?? 0;
  }

  void dispose() => _dataUpdateController.close();
}

