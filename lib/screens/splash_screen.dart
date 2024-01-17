import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Builder(
            builder: (context) {
              final splashScreenController = Provider.of<SplashScreenProvider>(context, listen: false);
            
              splashScreenController.startAnimation();
              splashScreenController.onAnimationEnd(context);
            
              return Lottie.asset('assets/lottie_animations/splash_animation.json');
            },
          ),
        ),
      ),
    );
  }
}