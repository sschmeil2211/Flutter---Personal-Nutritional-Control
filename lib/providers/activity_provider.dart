import 'package:flutter/foundation.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository = ActivityRepository();
  List<ActivityModel>? _activities;

  ActivityProvider() {
    init();
  }

  List<ActivityModel> get activities => _activities ?? [];

  Future<void> init() async {
    _activities = await _activityRepository.getActivities();
    notifyListeners();
  }

  List<ActivityModel> filterActivitiesByName(String name) => activities
      .where((activity) => activity.activity.toLowerCase().contains(name.toLowerCase())).toList();
}