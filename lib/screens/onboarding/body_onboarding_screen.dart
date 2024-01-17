import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class BodyOnBoardingScreen extends StatelessWidget {
  const BodyOnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                    image: const AssetImage(appLogo),
                    height: height * 0.2
                  ),
                  const Text(
                    "Body Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  const BodyForm(),
                ],
              ),
            ),
          )
      ),
    );
  }
}