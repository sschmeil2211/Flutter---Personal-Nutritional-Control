// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class SplashScreenProvider extends ChangeNotifier {
  late bool _isLoading;

  Future<void> startAnimation() async {
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 2000));
    notifyListeners();
  }

  void onAnimationEnd(Function() function){
    if(_isLoading)
      Future.delayed(const Duration(milliseconds: 2000), function);
    _isLoading = false;
  }
}