import 'package:personal_nutrition_control/models/food_model.dart';
import 'package:personal_nutrition_control/models/user_model.dart';

GenreType getGenderType(String? genreTypeString) {
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
    case 'OnBoardingStatus.personal':
      return OnBoardingStatus.personal;
    case 'OnBoardingStatus.body':
      return OnBoardingStatus.body;
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

String getGenderString(GenreType gender) {
  String enumString = gender.toString().split('.').last;
  return enumString[0].toUpperCase() + enumString.substring(1);
}

String getPhysicalActivityString(PhysicalActivity physicalActivity) {
  switch(physicalActivity){
    case PhysicalActivity.lessThanHour:
      return 'Less than 1 hs';
    case PhysicalActivity.twoToFive:
      return '2 to 5 hs';
    case PhysicalActivity.sixToNine:
      return '6 to 9 hs';
    case PhysicalActivity.tenToTwenty:
      return '10 to 20 hs';
    case PhysicalActivity.moreThanTwenty:
      return 'More than 20 hs';
  }
}

PhysicalActivity getPhysicalActivityType(String? physicalActivity){
  switch(physicalActivity){
    case 'PhysicalActivity.lessThanHour':
      return PhysicalActivity.lessThanHour;
    case 'PhysicalActivity.twoToFive':
      return PhysicalActivity.twoToFive;
    case 'PhysicalActivity.sixToNine':
      return PhysicalActivity.sixToNine;
    case 'PhysicalActivity.tenToTwenty':
      return PhysicalActivity.tenToTwenty;
    case 'PhysicalActivity.moreThanTwenty':
      return PhysicalActivity.moreThanTwenty;
    default:
      return PhysicalActivity.lessThanHour;
  }
}