import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/widgets/calendar_widgets/CalendarBody.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: CalendarBody()
        ),
      ),
    );
  }
}