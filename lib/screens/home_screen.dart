// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white24,
        onPressed: () => Navigator.pushNamed(context, 'foodListScreen'),
        child: const Icon(Icons.food_bank),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Consumer<DayProvider>(
              builder: (context, dayProvider, child){

                UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
                DayModel? actualDay = dayProvider.actualDay;
                if(user == null || actualDay == null)
                  return Container();

                final DayModel? day = dayProvider.getSpecificDay(DateTime.now());
                if(day == null)
                  return Container();

                return DiaryIndicators(dayToView: day);
              }
            ),
            const AddTodayFood(),
          ],
        ),
      ),
    );
  }
}