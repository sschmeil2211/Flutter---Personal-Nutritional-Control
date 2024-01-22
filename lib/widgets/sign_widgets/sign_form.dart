// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/models.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

class SignForm extends StatefulWidget {

  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {

  bool signInView = false;
  bool loading = false;
  bool passwordVisible = true;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void signStatusAction(String? message, String routeName){
    if(message == null)
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
    else{
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(message, Colors.deepOrange));
    }
  }

  Future<void> singUp(UserProvider userProvider) async {
    if(email.text.isEmpty || password.text.isEmpty || username.text.isEmpty) return;
    setState(() => loading = true);
    String? message = await userProvider.signUp(email.text, password.text, username.text);
    signStatusAction(message, 'personalOnboardingScreen');
  }

  Future<void> singIn(UserProvider userProvider) async {
    if(email.text.isEmpty || password.text.isEmpty) return;
    setState(() => loading = true);
    String? message = await userProvider.signIn(email.text, password.text);
    await userProvider.loadUser();
    signStatusAction(message, 'homeScreen');
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String signTitle = signInView ? "Sing Up" : "Sign In";
    String signButtonText = signInView ? "If you have an account, sign in!" : "If you don't have an account, sign up!";
    List<InputFieldsData> data = InputFieldsData.signInputs(username, email, password);
    
    return Column(
      children: [
        Text(
          signTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
        Form(
          child: Column(
            children: [
              ...data
                  .skip(signInView ? 0 : 1) // Omitir el primer elemento si signView es true
                  .map((e) => InputField(
                      prefixIcon: e.iconData,
                      labelText: e.label,
                      textEditingController: e.controller,
                      obscureText: e.label.contains('Password') ? passwordVisible : false,
                      onPressedIcon: e.label.contains('Password')
                          ? () => setState(() => passwordVisible = !passwordVisible)
                          : null,
                    )).toList(),
            ],
          )
        ),
        ButtonIndicator(
          isLoading: loading,
          label: signTitle,
          onPressed: () async => signInView
              ? await singUp(userProvider)
              : await singIn(userProvider),
        ),
        TextButton(
          onPressed: (){},
          child: const Text("Forget password")
        ),
        TextButton(
          onPressed: () => setState(() => signInView = !signInView),
          child: Text(signButtonText)
        ),
      ],
    );
  }
}