import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/ExpandableFloatinButtonWidgets.dart';
import 'package:personal_nutrition_control/widgets/home_widgets/DashboardsWidgets.dart';
import 'package:personal_nutrition_control/widgets/home_widgets/HomeWidgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => print("s"),
            icon: const Icon(Icons.dashboard),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1.4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.search, color: Colors.grey),
                          ),
                          Text('Find Food to add', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                const DiaryIndicators(),
                const AddTodayFood(),
              ],
            ),
          ),/*
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar()
          )*/
        ],
      ),
    );
  }
}