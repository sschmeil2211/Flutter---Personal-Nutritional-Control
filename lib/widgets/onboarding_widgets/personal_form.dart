// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/utils/enum_utils.dart';
import 'package:personal_nutrition_control/utils/form_utils.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/text_input.dart';
import 'package:provider/provider.dart';

class PersonalForm extends StatefulWidget {

  const PersonalForm({super.key});

  @override
  State<PersonalForm> createState() => _PersonalFormFormState();
}

class _PersonalFormFormState extends State<PersonalForm> {

  bool loading = false;
  DateTime? selectedDate;
  PhysicalActivity? selectedPhysicalActivity;
  GenreType? selectedGenderType;

  TextEditingController physicalActivityController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  Future<void> updateUser(UserProvider userProvider) async {
    if(physicalActivityController.text.isEmpty || genderController.text.isEmpty || birthdateController.text.isEmpty) return;
    UserModel? newUser = userProvider.user?.copyFrom(
      weeklyPhysicalActivity: selectedPhysicalActivity,
      genreType: selectedGenderType,
      birthdate: '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
      onBoardingStatus: OnBoardingStatus.body
    );
    setState(() async => loading = true);
    bool successful = await userProvider.updateUser(newUser!);
    if(successful)
      Navigator.pushReplacementNamed(context, 'bodyOnboardingScreen');
    setState(() => loading = false);
  }

  Future<void> onPressedCalendarModal() async {
    DateTime? result = await dateResult(context, selectedDate);
    if(result == null || result == selectedDate) return;
    setState(() {
      selectedDate = result;
      birthdateController.text = DateFormat('d MMM y').format(selectedDate!);
    });
  }

  Future<void> onPressedGenderModal() async {
    GenreType? result = await genderResult(context);
    if(result == null) return;
    setState(() {
      selectedGenderType = result;
      genderController.text = getGenderString(selectedGenderType!);
    });
  }

  Future<void> onPressedPhysicalModal() async {
    PhysicalActivity? result = await physicalActivityResult(context);
    if(result == null) return;
    setState(() {
      selectedPhysicalActivity = result;
      physicalActivityController.text = getPhysicalActivityString(selectedPhysicalActivity!);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        inputField(Icons.person, 'Gender', genderController, onPressedGenderModal),
        inputField(Icons.calendar_month, 'Birthdate', birthdateController, onPressedCalendarModal),
        inputField(Icons.timer, 'Physical activity per week (hs)', physicalActivityController, onPressedPhysicalModal),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: indicator(userProvider),
        )
      ],
    );
  }

  Widget inputField(IconData icon, String label, TextEditingController controller, Function() onTap) => InputField(
    readOnly: true,
    textInputType: TextInputType.none,
    prefixIcon: icon,
    labelText: label,
    textEditingController: controller,
    onTap: onTap,
  );

  Widget indicator(UserProvider userProvider) => loading
      ? const CircularProgressIndicator()
      : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: const Text('Continue'),
            onPressed: () async => await updateUser(userProvider),
          )
        );
}