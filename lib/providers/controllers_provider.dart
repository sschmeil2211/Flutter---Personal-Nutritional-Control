import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/models/models.dart';

class ControllersProvider with ChangeNotifier {
  //TextEditingControllers
  final TextEditingController _targetCaloriesController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _wristController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _physicalActivityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  //Auxiliaries
  DateTime? _selectedDate;
  PhysicalActivity? _selectedPhysicalActivity;
  GenderType? _selectedGenderType;

  //Getters
  TextEditingController get targetCaloriesController => _targetCaloriesController;
  TextEditingController get heightController => _heightController;
  TextEditingController get weightController => _weightController;
  TextEditingController get wristController => _wristController;
  TextEditingController get waistController => _waistController;
  TextEditingController get genderController => _genderController;
  TextEditingController get physicalActivityController => _physicalActivityController;
  TextEditingController get birthdateController => _birthdateController;

  DateTime? get selectedDate => _selectedDate;
  GenderType? get selectedGenderType => _selectedGenderType;
  PhysicalActivity? get selectedPhysicalActivity => _selectedPhysicalActivity;

  bool get isTargetCaloriesEmpty => _targetCaloriesController.text.isEmpty;
  bool get isHeightEmpty => _heightController.text.isEmpty;
  bool get isWeightEmpty => _weightController.text.isEmpty;
  bool get isWristEmpty => _wristController.text.isEmpty;
  bool get isWaistEmpty => _waistController.text.isEmpty;
  bool get isGenderEmpty => _genderController.text.isEmpty;
  bool get isPhysicalActivityEmpty => _physicalActivityController.text.isEmpty;
  bool get isBirthdateEmpty => _birthdateController.text.isEmpty;


  void setUserProvider(UserProvider userProvider){
    UserModel? user = userProvider.user;
    if(user == null) return;
    String targetCalories = user.targetCalories % 1 == 0
        ? user.targetCalories.toString()
        : user.targetCalories.toStringAsFixed(2);

    _targetCaloriesController.text = targetCalories;
    _heightController.text = user.height.toString();
    _weightController.text = user.weight.toString();
    _wristController.text = user.wrist.toString();
    _waistController.text = user.waist.toString();
    _genderController.text = getGenderString(user.genderType);
    _physicalActivityController.text = getPhysicalActivityString(user.weeklyPhysicalActivity);
    _birthdateController.text = DateFormat('d MMM y').format(getFormattedDateTime(user.birthdate));
    _selectedDate = getFormattedDateTime(user.birthdate);
  }

  //Modal to fill Aux and save data to TextEditingControllers

  Future<void> onPressedCalendarModal(BuildContext context) async {
    DateTime? result = await dateResult(context, selectedDate);
    if(result == null || result == _selectedDate) return;
    _selectedDate = result;
    _birthdateController.text = DateFormat('d MMM y').format(selectedDate!);
    notifyListeners();
  }

  Future<void> onPressedGenderModal(BuildContext context) async {
    GenderType? result = await genderResult(context);
    if(result == null) return;
    _selectedGenderType = result;
    genderController.text = getGenderString(_selectedGenderType!);
    notifyListeners();
  }

  Future<void> onPressedPhysicalModal(BuildContext context) async {
    PhysicalActivity? result = await physicalActivityResult(context);
    if(result == null) return;
    _selectedPhysicalActivity = result;
    _physicalActivityController.text = getPhysicalActivityString(selectedPhysicalActivity!);
    notifyListeners();
  }
}