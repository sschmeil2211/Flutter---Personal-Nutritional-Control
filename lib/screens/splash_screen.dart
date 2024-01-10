import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personal_nutrition_control/providers/splash_screen_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            final splashScreenController = Provider.of<SplashScreenController>(context, listen: false);

            splashScreenController.startAnimation();
            splashScreenController.onAnimationEnd(context);

            return Lottie.asset('assets/lottie_animations/splash_animation.json');
          },
        ),
      ),
    );
  }
}