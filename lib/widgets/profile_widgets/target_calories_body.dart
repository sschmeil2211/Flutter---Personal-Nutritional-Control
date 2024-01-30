// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class TargetCaloriesBody extends StatelessWidget {
  const TargetCaloriesBody({super.key});

  @override
  Widget build(BuildContext context) {

    ControllersProvider controllersProvider = Provider.of<ControllersProvider>(context, listen: false);

    return Column(
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Text(
              'Here you can see the daily calories that correspond to you based on the entered data.\n'
              'This value will be updated automatically as long as you keep your personal information up to date.\n'
              'If you want to customize your calorie limit, you can do so by pressing the Edit button.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        TargetCaloriesInput(
          targetCaloriesController: controllersProvider.targetCaloriesController,
          readOnly: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MaterialButton(
            color: Colors.white12,
            minWidth: double.infinity,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10)
              )
            ),
            child: const Text('Edit Target calories'),
            onPressed: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => TargetCaloriesModal(controllersProvider: controllersProvider)
            )
          ),
        )
      ],
    );
  }
}

class TargetCaloriesModal extends StatefulWidget {
  final ControllersProvider controllersProvider;

  const TargetCaloriesModal({
    required this.controllersProvider,
    super.key
  });

  @override
  State<TargetCaloriesModal> createState() => _TargetCaloriesModalState();
}

class _TargetCaloriesModalState extends State<TargetCaloriesModal> {
  bool loading = false;

  Future<void> onPressed(UserProvider userProvider) async {
    UserModel? newUser = userProvider.user?.copyFrom(
      targetCalories: double.parse(widget.controllersProvider.targetCaloriesController.text),
    );
    setState(() => loading = true);
    bool successful = await userProvider.updateUser(newUser);
    if(!context.mounted) return;
    if(successful)
      Navigator.pushNamedAndRemoveUntil(context, 'profileScreen', (route) => false);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

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
                TargetCaloriesInput(
                  targetCaloriesController: widget.controllersProvider.targetCaloriesController,
                ),
                ButtonWithLoading(
                  label: 'Update',
                  isLoading: loading,
                  onPressed: () async => await onPressed(userProvider)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TargetCaloriesInput extends StatelessWidget {
  final TextEditingController targetCaloriesController;
  final bool readOnly;

  const TargetCaloriesInput({
    required this.targetCaloriesController,
    this.readOnly = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InputField(
        prefixIcon: Icons.calculate_outlined,
        labelText: 'Target Calories per Day',
        textEditingController: this.targetCaloriesController,
        readOnly: this.readOnly,
      ),
    );
  }
}