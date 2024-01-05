// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/DayModel.dart';
import 'package:personal_nutrition_control/models/UserModel.dart';
import 'package:personal_nutrition_control/providers/DayProvider.dart';
import 'package:personal_nutrition_control/providers/UserProvider.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/ExpandableFloatinButtonWidgets.dart';
import 'package:personal_nutrition_control/widgets/home_widgets/DashboardsWidgets.dart';
import 'package:personal_nutrition_control/widgets/home_widgets/HomeWidgets.dart';
import 'package:personal_nutrition_control/widgets/home_widgets/Searcher.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.pushNamed(context, 'calendarScreen'),
          ),
          ActionButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.pushNamed(context, 'foodListScreen'),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Searcher(),
                ),
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
        ],
      ),
    );
  }
}