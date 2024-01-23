import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/delegates/search_delegate.dart';
import 'package:personal_nutrition_control/providers/food_provider.dart';

class Searcher extends StatelessWidget {

  const Searcher({super.key});

  @override
  Widget build(BuildContext context) {
    FoodProvider foodProvider = Provider.of<FoodProvider>(context, listen: false);

    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrange, width: 1.4),
          borderRadius: BorderRadius.circular(25),
        ),
        child: InkWell(
          onTap: () => showSearch(
            context: context,
            delegate: FoodSearchDelegate(foodProvider),
          ),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search, color: Colors.grey),
              ),
              Text('Find Food to add', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}