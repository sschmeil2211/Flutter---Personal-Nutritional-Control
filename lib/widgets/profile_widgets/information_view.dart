// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class InformationView extends StatefulWidget {
  final int args;
  final UserProvider userProvider;

  const InformationView({
    required this.args,
    required this.userProvider,
    super.key
  });

  @override
  State<InformationView> createState() => _InformationViewState();
}

class _InformationViewState extends State<InformationView> {

  bool loading = false;

  Future<void> updateUser(ControllersProvider controllersProvider) async {
    UserModel? newUser = widget.args == 0
        ? widget.userProvider.user?.copyFrom(
            weeklyPhysicalActivity: controllersProvider.selectedPhysicalActivity,
            genderType: controllersProvider.selectedGenderType,
            birthdate: '${controllersProvider.selectedDate?.year}-${controllersProvider.selectedDate?.month}-${controllersProvider.selectedDate?.day}',
          )
        : widget.userProvider.user?.copyFrom(
            height: int.parse(controllersProvider.heightController.text),
            weight: int.parse(controllersProvider.weightController.text),
            wrist: int.parse(controllersProvider.wristController.text),
            waist: int.parse(controllersProvider.waistController.text),
          );
    setState(() => loading = true);
    if(newUser == null) return;
    bool successful = await widget.userProvider.updateUser(newUser);
    if(!context.mounted) return;
    if(successful)
      showCupertinoModalPopup(
        context: context,
        builder: (context) => RecalculateTargetCaloriesModal(userProvider: widget.userProvider)
      );
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    ControllersProvider controllersProvider = Provider.of<ControllersProvider>(context, listen: false);

    List<InputFieldsData> inputs = widget.args == 0
        ? InputFieldsData.personalInputs(context, controllersProvider)
        : InputFieldsData.bodyInputs(controllersProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: inputs.map((input) => InputField(
            prefixIcon: input.iconData,
            labelText: input.label,
            textEditingController: input.controller,
            readOnly: input.readOnly,
            textInputType: input.textInputType,
            onTap: input.function,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
          )).toList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ButtonIndicator(
            label: 'Update',
            isLoading: loading,
            onPressed: () async => await updateUser(controllersProvider),
          ),
        )
      ],
    );
  }
}

class RecalculateTargetCaloriesModal extends StatefulWidget {
  final UserProvider userProvider;

  const RecalculateTargetCaloriesModal({
    required this.userProvider,
    super.key
  });

  @override
  State<RecalculateTargetCaloriesModal> createState() => _RecalculateTargetCaloriesModalState();
}

class _RecalculateTargetCaloriesModalState extends State<RecalculateTargetCaloriesModal> {
  bool loading = false;

  Future<void> onPressed() async {
    setState(() => loading = true);
    UserModel? newUser = widget.userProvider.user!.copyFrom(
      targetCalories: Calculations(widget.userProvider.user!).getRecommendedCalories()
    );
    bool successful = await widget.userProvider.updateUser(newUser);
    if(!context.mounted) return;
    if(successful)
      Navigator.pop(context);
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
                const Text('Your information has changed, we need to recalculate your target calories.'),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ButtonIndicator(
                    label: 'Update',
                    isLoading: loading,
                    onPressed: onPressed,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
