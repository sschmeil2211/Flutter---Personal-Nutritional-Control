// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/text_input.dart';
import 'package:provider/provider.dart';

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
    if(successful)
      Navigator.pushReplacementNamed(context, 'creationUserLoadingScreen');
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