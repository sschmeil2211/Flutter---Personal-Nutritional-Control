// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class PersonalForm extends StatefulWidget {

  const PersonalForm({super.key});

  @override
  State<PersonalForm> createState() => _PersonalFormFormState();
}

class _PersonalFormFormState extends State<PersonalForm> {

  bool loading = false;
  DateTime? selectedDate;
  PhysicalActivity? selectedPhysicalActivity;
  GenderType? selectedGenderType;

  TextEditingController physicalActivityController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  Future<void> updateUser(UserProvider userProvider) async {
    if(physicalActivityController.text.isEmpty || genderController.text.isEmpty || birthdateController.text.isEmpty) return;
    UserModel? newUser = userProvider.user?.copyFrom(
      weeklyPhysicalActivity: selectedPhysicalActivity,
      genderType: selectedGenderType,
      birthdate: '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
      onBoardingStatus: OnBoardingStatus.body
    );
    setState(() => loading = true);
    bool successful = await userProvider.updateUser(newUser!);
    if(!context.mounted) return;
    if(successful)
      Navigator.pushNamedAndRemoveUntil(context, 'bodyOnboardingScreen', (route) => false,);
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
    GenderType? result = await genderResult(context);
    if(result == null) return;
    setState(() {
      selectedGenderType = result;
      genderController.text = formatEnumName(selectedGenderType!);
    });
  }

  Future<void> onPressedPhysicalModal() async {
    PhysicalActivity? result = await physicalActivityResult(context);
    if(result == null) return;
    setState(() {
      selectedPhysicalActivity = result;
      physicalActivityController.text = formatEnumName(selectedPhysicalActivity!);
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

class BodyForm extends StatefulWidget {

  const BodyForm({super.key});

  @override
  State<BodyForm> createState() => _BodyFormFormState();
}

class _BodyFormFormState extends State<BodyForm> {

  bool loading = false;

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController wristController = TextEditingController();
  TextEditingController waistController = TextEditingController();

  Future<void> updateUser(UserProvider userProvider) async {
    if(heightController.text.isEmpty || weightController.text.isEmpty || wristController.text.isEmpty || waistController.text.isEmpty) return;
    UserModel? newUser = userProvider.user?.copyFrom(
      height: int.parse(heightController.text),
      weight: int.parse(weightController.text),
      wrist: int.parse(wristController.text),
      waist: int.parse(waistController.text),
      onBoardingStatus: OnBoardingStatus.finalized,
    );
    setState(() => loading = true);
    bool successful = await userProvider.updateUser(newUser);
    if(!context.mounted) return;
    if(successful)
      Navigator.pushNamedAndRemoveUntil(context, 'creationUserLoadingScreen', (route) => false);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        inputField(Icons.height, 'Height', heightController),
        inputField(Icons.scale, 'Weight', weightController),
        inputField(Icons.circle_outlined, 'Wrist circumference', wristController),
        inputField(Icons.circle, 'Waist circumference', waistController),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: indicator(userProvider),
        )
      ],
    );
  }

  Widget inputField(IconData icon, String label, TextEditingController controller) => InputField(
    prefixIcon: icon,
    labelText: label,
    textEditingController: controller,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
    textInputType: const TextInputType.numberWithOptions(signed: false, decimal: true),
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