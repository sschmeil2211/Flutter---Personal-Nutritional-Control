// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'dart:math';

import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/utils/fortmatter.dart';

class Calculations {
  final UserModel user;
  int height;
  int weight;
  /*int wrist;
  int waist;*/
  DateTime birthDate;
  PhysicalActivity physicalActivity;

  Calculations(this.user)
      : this.height = user.height,
        this.weight = user.weight,
        /*this.wrist = user.wrist,
        this.waist = user.waist,*/
        this.birthDate = getFormattedDateTime(user.birthdate),
        this.physicalActivity = user.weeklyPhysicalActivity;

  //Body Mass Index
  double get userBMI => this.weight / pow(this.height / 100, 2);

  int get userAge => DateTime.now().difference(this.birthDate).inDays ~/ 365;

  double get femaleTMR{
    switch(this.physicalActivity){
      case PhysicalActivity.lessThanHour:
        return 1.3;
      case PhysicalActivity.twoToFive:
        return 1.56;
      case PhysicalActivity.sixToNine:
        return 1.64;
      case PhysicalActivity.tenToTwenty:
        return 1.82;
      case PhysicalActivity.moreThanTwenty:
        return 2.2;
    }
  }

  double get maleTMR{
    switch(this.physicalActivity){
      case PhysicalActivity.lessThanHour:
        return 1.3;
      case PhysicalActivity.twoToFive:
        return 1.55;
      case PhysicalActivity.sixToNine:
        return 1.78;
      case PhysicalActivity.tenToTwenty:
        return 2.1;
      case PhysicalActivity.moreThanTwenty:
        return 2.4;
    }
  }

  //Harris-Benedict (basal Metabolism Rate)
  double get userBMR => user.genreType == GenreType.male
      ? (66.4730 + (13.7516 * this.weight) + (5.0033 * this.height) - (6.7550 * userAge))
      : (655.0955 + (9.5634 * this.weight) + (1.8496 * this.height) - (4.6756 * userAge));

  double getRecommendedCalories() {
    double recommendedDiaryCalories = user.genreType == GenreType.male
      ? userBMR * maleTMR
      : userBMR * femaleTMR;
    if(userBMI > 25)
      recommendedDiaryCalories -= 450;
    else if(userBMI < 18.5)
      recommendedDiaryCalories += 400;
    return recommendedDiaryCalories;
  }
}