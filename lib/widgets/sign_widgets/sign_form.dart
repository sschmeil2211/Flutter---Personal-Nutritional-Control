// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class SignInForm extends StatefulWidget {

  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  bool signView = false;
  bool loading = false;
  bool passwordVisible = true;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void signStatusAction(String? message, String routeName){
    if(message == null)
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false,);
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
    String signTitle = signView ? "Sing Up" : "Sign In";
    String signButtonText = signView ? "If you have an account, sign in!" : "If you don't have an account, sign up!";

    return Column(
      children: [
        Text(
          signTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
        Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(signView)
                  InputField(
                    prefixIcon: Icons.person_outline_outlined,
                    labelText: "Username",
                    textEditingController: username
                  ),
                InputField(
                  prefixIcon: Icons.mail_outline,
                  labelText: "Email",
                  textEditingController: email
                ),
                InputField(
                  prefixIcon: Icons.fingerprint,
                  labelText: "Password",
                  obscureText: passwordVisible,
                  onPressedIcon: () => setState(() => passwordVisible = !passwordVisible),
                  textEditingController: password
                ),
              ],
            )
        ),
        signIndicator(userProvider, signTitle),
        TextButton(
          onPressed: (){},
          child: const Text("Forget password")
        ),
        TextButton(
          onPressed: () => setState(() => signView = !signView),
          child: Text(signButtonText)
        ),
      ],
    );
  }

  Widget signIndicator(UserProvider userProvider, String signTitle) => loading
      ? const CircularProgressIndicator()
      : SizedBox(width: double.infinity, child: signButton(userProvider, signTitle));

  Widget signButton(UserProvider userProvider, String signTitle) => ElevatedButton(
      child: Text(signTitle),
      onPressed: () async => signView
          ? await singUp(userProvider)
          : await singIn(userProvider),
  );
}