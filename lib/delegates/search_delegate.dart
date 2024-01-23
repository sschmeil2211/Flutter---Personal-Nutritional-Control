// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class FoodSearchDelegate extends SearchDelegate<void> {
  final FoodProvider foodProvider;

  FoodSearchDelegate(this.foodProvider);

  MealTime? mealTime;
  String keyboardText = '0';

  @override
  ThemeData appBarTheme( BuildContext context ) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 1.5, color: Colors.deepOrange),
    );
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        titleSpacing: 15,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: const BoxConstraints(maxHeight: 35),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<FoodModel> searchResults = foodProvider.filterFoodsByName(query);
    return buildSearchResults(searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<FoodModel> searchResults = foodProvider.filterFoodsByName(query);
    return buildSearchResults(searchResults);
  }

  Widget buildSearchResults(List<FoodModel> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        FoodModel food = searchResults[index];
        return FoodCard(
          foodModel: food,
          onTap: () => showModal(
            context: context,
            child: FoodCardModal(
              buttonLabel: "Save",
              onKeyboardTap: (text) => keyboardText = text,
              onChangeMealTime: (value) => mealTime = value,
              onPressed: () async {
                DayProvider dayProvider = Provider.of<DayProvider>(context, listen: false);
                await dayProvider.handleDay(mealTime ?? MealTime.appetizer, food, double.parse(keyboardText));
                if(!context.mounted) return;
                Navigator.pop(context);
              },
            )
          ),
        );
      },
    );
  }
}