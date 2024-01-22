import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

Future<PhysicalActivity?> physicalActivityResult(BuildContext context) async => await showModalBottomSheet<PhysicalActivity>(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  builder: (_) => const EnumSelector(
    enumValues: PhysicalActivity.values,
    title: '* We need your biological gender for some calculations.',
  ),
);

Future<GenderType?> genderResult(BuildContext context) async => await showModalBottomSheet<GenderType>(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  builder: (_) => const EnumSelector(
    enumValues: GenderType.values,
    title: '* We need your biological gender for some calculations.',
  ),
);

Future<DateTime?> dateResult(BuildContext context, DateTime? selectedDate) async => await showDatePicker(
  context: context,
  initialDate: selectedDate,
  firstDate: DateTime(1930),
  lastDate: DateTime.now(),
);

void showModal({required BuildContext context, required Widget child}){
  showModalBottomSheet(
    enableDrag: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15)
      )
    ),
    builder: (context) => child
  );
}