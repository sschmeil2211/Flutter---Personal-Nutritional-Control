// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/services/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Builder(
            builder: (context) {
              SplashScreenProvider splashScreenController = Provider.of<SplashScreenProvider>(context, listen: false);
              UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
            
              splashScreenController.startAnimation();
              splashScreenController.onAnimationEnd(() {
                if(AuthService().currentUser == null || userProvider.user == null)
                  Navigator.pushReplacementNamed(context, 'signScreen');
                else{
                  if(userProvider.user?.onBoardingStatus == OnBoardingStatus.finalized)
                    Navigator.pushReplacementNamed(context, 'homeScreen');
                  else if(userProvider.user?.onBoardingStatus == OnBoardingStatus.personal)
                    Navigator.pushReplacementNamed(context, 'personalOnboardingScreen');
                  else
                    Navigator.pushReplacementNamed(context, 'bodyOnboardingScreen');
                }
              });
            
              return Lottie.asset('assets/lottie_animations/splash_animation.json');
            },
          ),
        ),
      ),
    );
  }
}