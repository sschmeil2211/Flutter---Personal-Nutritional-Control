import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/user_model.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/services/auth_service.dart';
import 'package:provider/provider.dart';

class SplashScreenController extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

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
}