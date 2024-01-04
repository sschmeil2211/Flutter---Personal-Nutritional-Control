// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/widgets/calendar_widgets/CalendarWidgets.dart';

import 'package:personal_nutrition_control/widgets/home_widgets/DashboardsWidgets.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            DiaryIndicators(),
            MealTimeCard()
          ],
        ),
      ),
    );
  }
}