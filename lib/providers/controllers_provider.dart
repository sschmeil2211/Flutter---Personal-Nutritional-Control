import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/utils/enum_utils.dart';
import 'package:personal_nutrition_control/utils/form_utils.dart';
import 'package:personal_nutrition_control/utils/fortmatter.dart';

class ControllersProvider with ChangeNotifier {
  final TextEditingController _targetCalories = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _wristController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _physicalActivityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  DateTime? _selectedDate;
  PhysicalActivity? _selectedPhysicalActivity;
  GenreType? _selectedGenderType;

  TextEditingController get targetCalories => _targetCalories;
  TextEditingController get heightController => _heightController;
  TextEditingController get weightController => _weightController;
  TextEditingController get wristController => _wristController;
  TextEditingController get waistController => _waistController;
  TextEditingController get genderController => _genderController;
  TextEditingController get physicalActivityController => _physicalActivityController;
  TextEditingController get birthdateController => _birthdateController;

  DateTime? get selectedDate => _selectedDate;
  GenreType? get selectedGenderType => _selectedGenderType;
  PhysicalActivity? get selectedPhysicalActivity => _selectedPhysicalActivity;

  void setUserProvider(UserProvider userProvider){
    if(userProvider.user == null) return;
    setControllers(userProvider.user);
  }

  void setControllers(UserModel? user) {
    if (user == null) return;
    _targetCalories.text = user.targetCalories.toString();
    _heightController.text = user.height.toString();
    _weightController.text = user.weight.toString();
    _wristController.text = user.wrist.toString();
    _waistController.text = user.waist.toString();
    _genderController.text = getGenderString(user.genreType);
    _physicalActivityController.text = getPhysicalActivityString(user.weeklyPhysicalActivity);
    _birthdateController.text = DateFormat('d MMM y').format(getFormattedDateTime(user.birthdate));
    _selectedDate = getFormattedDateTime(user.birthdate);
  }

  Future<void> onPressedCalendarModal(BuildContext context) async {
    DateTime? result = await dateResult(context, selectedDate);
    if(result == null || result == _selectedDate) return;
    _selectedDate = result;
    _birthdateController.text = DateFormat('d MMM y').format(selectedDate!);
    notifyListeners();
  }

  Future<void> onPressedGenderModal(BuildContext context) async {
    GenreType? result = await genderResult(context);
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