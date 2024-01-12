import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/text_input.dart';

Future<PhysicalActivity?> physicalActivityResult(BuildContext context) async => await showModalBottomSheet<PhysicalActivity>(
  context: context,
  builder: (_) => const PhysicalTimeSelector(),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
);

Future<GenreType?> genderResult(BuildContext context) async => await showModalBottomSheet<GenreType>(
  context: context,
  builder: (_) => const GenderSelector(),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
);

Future<DateTime?> dateResult(BuildContext context, DateTime? selectedDate) async => await showDatePicker(
  context: context,
  initialDate: selectedDate,
  firstDate: DateTime(1930),
  lastDate: DateTime.now(),
);