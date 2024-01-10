import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "On Boarding",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  SignInForm(),
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}

class SignInForm extends StatefulWidget {

  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  bool signView = false;
  bool loading = false;

  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController waist = TextEditingController();
  TextEditingController wrist = TextEditingController();
  TextEditingController targetCalories = TextEditingController();

  Future<void> updateUser(UserProvider userProvider) async {
    UserModel? newUser = userProvider.user?.copyFrom(
      height: int.parse(height.text),
      weight: double.parse(weight.text),
      wrist: int.parse(wrist.text),
      waist: int.parse(waist.text),
      targetCalories: int.parse(targetCalories.text),
    );
    setState(() => loading = true);
    if(newUser == null) return;
    print("123e412");
    await userProvider.updateUser(newUser).then((value) =>  Navigator.pushReplacementNamed(context, 'homeScreen'));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return Column(
      children: [
        Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextInput(
                  prefixIcon: Icons.person_outline_outlined,
                  labelText: "Height",
                  textEditingController: height
                ),
                TextInput(
                  prefixIcon: Icons.person_outline_outlined,
                  labelText: "Weight",
                  textEditingController: weight
                ),
                TextInput(
                  prefixIcon: Icons.mail_outline,
                  labelText: "Waist",
                  textEditingController: waist
                ),
                TextInput(
                  prefixIcon: Icons.fingerprint,
                  labelText: "Wrist",
                  textEditingController: wrist
                ),
                TextInput(
                  prefixIcon: Icons.fingerprint,
                  labelText: "Target Calories",
                  textEditingController: targetCalories
                ),
              ],
            )
        ),
        loading ? const CircularProgressIndicator() : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async => await updateUser(userProvider),
            child: const Text("Continue")
          ),
        ),
      ],
    );
  }
}

class TextInput extends StatelessWidget {

  final bool obscureText;
  final bool passwordVisibleSwitch;
  final Function()? onPressed;
  final IconData prefixIcon;
  final String labelText;
  final TextEditingController textEditingController;

  const TextInput({
    this.obscureText = false,
    this.passwordVisibleSwitch = false,
    this.onPressed,
    required this.prefixIcon,
    required this.labelText,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: this.textEditingController,
        obscureText: this.obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(this.prefixIcon),
            labelText: this.labelText,
            border: const OutlineInputBorder(),
            suffixIcon: this.passwordVisibleSwitch
                ? IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.remove_red_eye_sharp)
                ) : null
        ),
      ),
    );
  }
}