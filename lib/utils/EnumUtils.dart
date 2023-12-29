import 'package:personal_nutrition_control/models/FoodModel.dart';
import 'package:personal_nutrition_control/models/UserModel.dart';

GenreType getGenreType(String? genreTypeString) {
  switch (genreTypeString) {
    case 'GenreType.male':
      return GenreType.male;
    case 'GenreType.female':
      return GenreType.female;
    default:
      return GenreType.male; // Valor predeterminado o manejo de casos inesperados
  }
}

OnBoardingStatus getOnBoardingStatus(String? onBoardingStatusString) {
  switch (onBoardingStatusString) {
    case 'OnBoardingStatus.onboarding':
      return OnBoardingStatus.onboarding;
    case 'OnBoardingStatus.finalized':
      return OnBoardingStatus.finalized;
    default:
      return OnBoardingStatus.finalized; // Valor predeterminado o manejo de casos inesperados
  }
}

FoodType getFoodType(String? foodTypeString) {
  switch (foodTypeString) {
    case 'FoodType.meat':
      return FoodType.meat;
    case 'FoodType.dairy':
      return FoodType.dairy;
    case 'FoodType.drink':
      return FoodType.drink;
    case 'FoodType.fruit':
      return FoodType.fruit;
    case 'FoodType.grain':
      return FoodType.grain;
    case 'FoodType.legume':
      return FoodType.legume;
    case 'FoodType.nut':
      return FoodType.nut;
    case 'FoodType.processed':
      return FoodType.processed;
    case 'FoodType.sweet':
      return FoodType.sweet;
    case 'FoodType.vegetable':
      return FoodType.vegetable;
    case 'FoodType.other':
      return FoodType.other;
    default:
      return FoodType.other;
  }
}