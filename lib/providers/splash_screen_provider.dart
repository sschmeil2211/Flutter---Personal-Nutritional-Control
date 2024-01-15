// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/services/auth_service.dart';

class SplashScreenController extends ChangeNotifier {
  bool _isLoading = true;

  Future<void> startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _isLoading = false;
    notifyListeners();
  }

  void onAnimationEnd(BuildContext context) {
    if (_isLoading) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        AuthService().currentUser != null
            ? Navigator.pushReplacementNamed(context, 'homeScreen')
            : Navigator.pushReplacementNamed(context, 'signScreen');
      });
    }
  }

  void endAnimationWhenCreatingUser(Function() function){
    if(_isLoading)
      Future.delayed(const Duration(milliseconds: 2000), function);
  }
}