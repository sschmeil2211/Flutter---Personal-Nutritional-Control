// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

import 'package:personal_nutrition_control/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RecoveryPasswordScreen extends StatelessWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: const SafeArea(
        child: RecoveryPassword(),
      ),
    );
  }
}

class RecoveryPassword extends StatefulWidget {
  const RecoveryPassword({super.key});

  @override
  State<RecoveryPassword> createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {

  TextEditingController email = TextEditingController();
  bool loading = false;

  Future<void> onPressed(UserProvider userProvider) async {
    if(email.text.isEmpty) return;
    setState(() => loading = true);
    String? message = await userProvider.recoveryPassword(email.text);
    if(!context.mounted) return;
    if(message == null)
      Navigator.pop(context);
    else{
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(message, Colors.deepOrange));
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter your Email and we will send you a password reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          InputField(
            prefixIcon: Icons.email,
            labelText: 'Email',
            textEditingController: email
          ),
          ButtonWithLoading(
            isLoading: loading,
            onPressed: () async => await onPressed(userProvider),
            label: 'Send email'
          )
        ],
      ),
    );
  }
}
