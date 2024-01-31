import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/models.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            MaterialButton(
              shape: const CircleBorder(),
              color: Colors.white24,
              onPressed: () => Navigator.pushNamed(context, 'createFoodScreen'),
              child: const Icon(Icons.add, color: Colors.white, size: 22)
            )
          ],
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Common Foods'),
              Tab(text: 'My Foods'),
            ],
          ),
        ),
        body: SafeArea(
          child: Consumer<FoodProvider>(
            builder: (context, foodProvider, child){
              String userID = Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
              List<FoodModel> appFoods = foodProvider.foods.where((element) => element.addedBy.contains('app')).toList();
              List<FoodModel> userFoods = foodProvider.foods.where((element) => element.addedBy.contains(userID)).toList();
              return TabBarView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: appFoods.length,
                    itemBuilder: (context, index) => FoodCard(foodModel: appFoods[index])
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: userFoods.length,
                    itemBuilder: (context, index) => FoodCard(
                      foodModel: userFoods[index],
                      onTap: () => Navigator.pushNamed(context, 'createFoodScreen', arguments: userFoods[index]),
                    )
                  ),
                ]
              );
            }
          )
        ),
      ),
    );
  }
}
