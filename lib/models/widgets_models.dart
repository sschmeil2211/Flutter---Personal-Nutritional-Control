import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/providers/controllers_provider.dart';

class MacronutrientsData{
  final Color color;
  final double value;
  final String label;

  MacronutrientsData({
    required this.color,
    required this.value,
    required this.label
  });

  static List<MacronutrientsData> data(double carbs, double proteins, double fats) => [
    MacronutrientsData(color: Colors.yellowAccent, value: carbs, label: 'Carbs'),
    MacronutrientsData(color: Colors.lightBlue, value: proteins, label: 'Proteins'),
    MacronutrientsData(color: Colors.lightGreen, value: fats, label: 'Fats')
  ];
}

class InputFieldsData{
  final IconData iconData;
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType textInputType;
  final Function()? function;

  InputFieldsData({
    required this.iconData,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.textInputType = const TextInputType.numberWithOptions(signed: false, decimal: true),
    this.function
  });

  static List<InputFieldsData> bodyInputs(ControllersProvider controllersProvider) => [
    InputFieldsData(
      iconData: Icons.height,
      label: 'Height (cm)',
      controller: controllersProvider.heightController,
    ),
    InputFieldsData(
      iconData: Icons.scale,
      label: 'Weight (kg)',
      controller: controllersProvider.weightController,
    ),
    InputFieldsData(
      iconData: Icons.circle_outlined,
      label: 'Wrist circumference (cm)',
      controller: controllersProvider.wristController,
    ),
    InputFieldsData(
      iconData: Icons.circle,
      label: 'Waist circumference (cm)',
      controller: controllersProvider.waistController,
    ),
  ];

  static List<InputFieldsData> personalInputs(BuildContext context, ControllersProvider controllersProvider) => [
    InputFieldsData(
        iconData: Icons.person,
        label: 'Gender',
        readOnly: true,
        controller: controllersProvider.genderController,
        function: () async => await controllersProvider.onPressedGenderModal(context)
    ),
    InputFieldsData(
        iconData: Icons.calendar_month,
        label: 'Birthdate',
        readOnly: true,
        controller: controllersProvider.birthdateController,
        function: () async => await controllersProvider.onPressedCalendarModal(context)
    ),
    InputFieldsData(
        iconData: Icons.timer,
        label: 'Physical activity per week (hs)',
        readOnly: true,
        controller: controllersProvider.physicalActivityController,
        function: () async => await controllersProvider.onPressedPhysicalModal(context)
    ),
  ];

  static List<InputFieldsData> signInputs(TextEditingController username, TextEditingController email, TextEditingController password) => [
    InputFieldsData(iconData: Icons.person_outline_outlined, label: "Username", controller: username),
    InputFieldsData(iconData: Icons.mail_outline, label: "Email", controller: email),
    InputFieldsData(iconData: Icons.fingerprint, label: "Password", controller: password)
  ];
}

class ProfileCardData{
  final IconData iconData;
  final String label;
  final Function() function;

  ProfileCardData({
    required this.iconData,
    required this.label,
    required this.function,
  });

  static List<ProfileCardData> bodyData(BuildContext context) => [
    ProfileCardData(iconData: Icons.person, label: 'User Information', function: () => Navigator.pushNamed(context, 'informationScreen', arguments: 0)),
    ProfileCardData(iconData: Icons.scale, label: 'Body Information', function: () => Navigator.pushNamed(context, 'informationScreen', arguments: 1)),
    ProfileCardData(iconData: Icons.calculate_outlined, label: 'Target Calories', function: () => Navigator.pushNamed(context, 'targetCaloriesScreen')),
  ];
}