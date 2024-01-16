// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/controllers_provider.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/utils/calculations.dart';
import 'package:personal_nutrition_control/utils/enum_utils.dart';
import 'package:personal_nutrition_control/utils/form_utils.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/text_input.dart';
import 'package:provider/provider.dart';

class UserInformation extends StatefulWidget {
  final UserProvider userProvider;

  const UserInformation({
    required this.userProvider,
    super.key
  });

  @override
  State<UserInformation> createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<UserInformation> {

  bool loading = false;

  Future<void> updateUser(UserProvider userProvider, ControllersProvider controllersProvider) async {
    UserModel? newUser = userProvider.user?.copyFrom(
      weeklyPhysicalActivity: controllersProvider.selectedPhysicalActivity,
      genreType: controllersProvider.selectedGenderType,
      birthdate: '${controllersProvider.selectedDate?.year}-${controllersProvider.selectedDate?.month}-${controllersProvider.selectedDate?.day}',
    );
    setState(() => loading = true);
    if(userProvider.user == null) return;
    bool successful = await userProvider.updateUser(newUser!);
    if(successful)
      Navigator.of(context).pushNamedAndRemoveUntil('profileScreen', (route) => false);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Consumer<ControllersProvider>(
      builder: (context, controllersProvider, child){
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            inputField(
              Icons.person,
              'Gender',
              controllersProvider.genderController,
              () async => await controllersProvider.onPressedGenderModal(context)
            ),
            inputField(
              Icons.calendar_month,
              'Birthdate',
              controllersProvider.birthdateController,
              () async => await controllersProvider.onPressedCalendarModal(context)
            ),
            inputField(
              Icons.timer,
              'Physical activity per week (hs)',
              controllersProvider.physicalActivityController,
              () async => await controllersProvider.onPressedPhysicalModal(context)
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Indicator(
                isLoading: loading,
                onPressed: () async => await updateUser(userProvider, controllersProvider),
              ),
            )
          ],
        );
      },
    );
  }

  Widget inputField(IconData icon, String label, TextEditingController controller, Function() onTap) => InputField(
    prefixIcon: icon,
    labelText: label,
    textEditingController: controller,
    readOnly: true,
    textInputType: TextInputType.none,
    onTap: onTap,
  );
}

class UserBody extends StatefulWidget {
  final UserProvider userProvider;

  const UserBody({
    required this.userProvider,
    super.key
  });

  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  bool loading = false;

  Future<void> updateUser(UserProvider userProvider, ControllersProvider controllersProvider) async {
    UserModel? newUser = userProvider.user?.copyFrom(
      height: int.parse(controllersProvider.heightController.text),
      weight: int.parse(controllersProvider.weightController.text),
      wrist: int.parse(controllersProvider.wristController.text),
      waist: int.parse(controllersProvider.waistController.text),
    );
    setState(() => loading = true);
    if(userProvider.user == null) return;
    bool successful = await userProvider.updateUser(newUser!);
    if(successful)
      showCupertinoModalPopup(
        context: context,
        builder: (context) => UpdateTargetCalories(userProvider: userProvider)
      );
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    ControllersProvider controllersProvider = Provider.of<ControllersProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        inputField(Icons.height, 'Height (cm)', controllersProvider.heightController),
        inputField(Icons.scale, 'Weight (kg)', controllersProvider.weightController),
        inputField(Icons.circle_outlined, 'Wrist circumference (cm)', controllersProvider.wristController),
        inputField(Icons.circle, 'Waist circumference (cm)', controllersProvider.waistController),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Indicator(
            isLoading: loading,
            onPressed: () async => await updateUser(userProvider, controllersProvider),
          ),
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
}

class Indicator extends StatelessWidget {
  final bool isLoading;
  final Function() onPressed;

  const Indicator({
    required this.isLoading,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return this.isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: this.onPressed,
              child: const Text('Update'),
            )
          );
  }
}

class UpdateTargetCalories extends StatefulWidget {
  final UserProvider userProvider;

  const UpdateTargetCalories({
    required this.userProvider,
    super.key
  });

  @override
  State<UpdateTargetCalories> createState() => _UpdateTargetCaloriesState();
}

class _UpdateTargetCaloriesState extends State<UpdateTargetCalories> {
  bool loading = false;

  Future<void> onPressed() async {
    setState(() => loading = true);
    UserModel? newUser = widget.userProvider.user!.copyFrom(
      targetCalories: Calculations(widget.userProvider.user!).getRecommendedCalories()
    );
    bool successful = await widget.userProvider.updateUser(newUser);
    if(successful)
      Navigator.of(context).pushNamedAndRemoveUntil('profileScreen', (route) => false);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("data"),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: updateButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget updateButton() => loading
      ? const CircularProgressIndicator()
      : MaterialButton(
          color: Colors.white12,
          minWidth: double.infinity,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10)
            )
          ),
          onPressed: onPressed,
          child: const Text('Update'),
        );
}
