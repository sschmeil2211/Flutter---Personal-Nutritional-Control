import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/providers/UserProvider.dart';
import 'package:personal_nutrition_control/utils/ImagePaths.dart';
import 'package:provider/provider.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(appLogo),
                    height: height * 0.3
                  ),
                  const SignInForm(),
                ],
              ),
            ),
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

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> singUp(UserProvider userProvider) async {
    if(email.text.isEmpty || password.text.isEmpty || username.text.isEmpty) return;
    setState(() => loading = true);
    await userProvider.signUp(email.text, password.text, username.text)
        .then((value) => Navigator.pushReplacementNamed(context, 'onBoardingScreen'));
  }

  Future<void> singIn(UserProvider userProvider) async {
    if(email.text.isEmpty || password.text.isEmpty) return;
    setState(() => loading = true);
    await userProvider.signIn(email.text, password.text)
        .then((value) => Navigator.pushReplacementNamed(context, 'homeScreen'));
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
                TextInput(
                  prefixIcon: Icons.person_outline_outlined,
                  labelText: "Username",
                  textEditingController: username
                ),
              TextInput(
                prefixIcon: Icons.mail_outline,
                labelText: "Email",
                textEditingController: email
              ),
              TextInput(
                prefixIcon: Icons.fingerprint,
                labelText: "Password",
                textEditingController: password
              ),
            ],
          )
        ),
        loading ? const CircularProgressIndicator() : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async => signView ? await singUp(userProvider) : await singIn(userProvider),
            child: Text(signTitle)
          ),
        ),
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