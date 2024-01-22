import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),        
      ),
      body: SafeArea(
        child: Consumer<FoodProvider>(
          builder: (context, foodProvider, child) => ListView.builder(
            shrinkWrap: true,
            itemCount: foodProvider.foods.length,
            itemBuilder: (context, index) => FoodCard(
              foodModel: foodProvider.foods[index],
            )
          ),
        ),
      ),
    );
  }
}
