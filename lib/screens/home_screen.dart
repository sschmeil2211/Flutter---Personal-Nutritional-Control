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
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 15, left: 30, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Searcher(),
                      MaterialButton(
                        shape: const CircleBorder(),
                        color: Colors.white24,
                        elevation: 2,
                        onPressed: () => Navigator.pushNamed(context, 'profileScreen'),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.person)
                      ),
                    ],
                  ),
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
          ],
        ),
      ),
    );
  }
}