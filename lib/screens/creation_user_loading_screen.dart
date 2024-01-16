// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/splash_screen_provider.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/utils/calculations.dart';
import 'package:provider/provider.dart';

class CreationUserLoadingScreen extends StatelessWidget {
  const CreationUserLoadingScreen({super.key});

  Future<void> updateUser(UserProvider userProvider, BuildContext context) async { 
    UserModel newUser = userProvider.user!.copyFrom(
      targetCalories: Calculations(userProvider.user!).getRecommendedCalories()
    );
    bool successful = await userProvider.updateUser(newUser);
    if(successful)
      Navigator.pushReplacementNamed(context, 'homeScreen');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(
                builder: (context) {
                  SplashScreenController splashScreenController = Provider.of<SplashScreenController>(context, listen: false);
                  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

                  splashScreenController.startAnimation();
                  splashScreenController.endAnimationWhenCreatingUser(() => updateUser(userProvider, context));

                  return Lottie.asset('assets/lottie_animations/splash_animation.json');
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'We are creating your user.\nYou must wait a few seconds.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

