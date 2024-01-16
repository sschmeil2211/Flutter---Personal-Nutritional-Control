// ignore_for_file: unnecessary_this

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/controllers_provider.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/text_input.dart';
import 'package:provider/provider.dart';

class TargetCaloriesBody extends StatelessWidget {
  const TargetCaloriesBody({super.key});

  void onPressed(BuildContext context, ControllersProvider controllersProvider) => showCupertinoModalPopup(
    context: context,
    builder: (context) => TargetCaloriesModal(controllersProvider: controllersProvider)
  );

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
          targetCaloriesController: controllersProvider.targetCalories,
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
            onPressed: () => onPressed(context, controllersProvider),
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
      targetCalories: double.parse(this.widget.controllersProvider.targetCalories.text),
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
                  targetCaloriesController: this.widget.controllersProvider.targetCalories,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: updateButton(userProvider),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget updateButton(UserProvider userProvider) => loading
      ? const CircularProgressIndicator()
      : MaterialButton(
          color: Colors.white12,
          minWidth: double.infinity,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10)
            )
          ),
          onPressed: () async => await onPressed(userProvider),
          child: const Text('Update'),
        );
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

