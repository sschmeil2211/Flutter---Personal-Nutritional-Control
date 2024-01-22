// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class SwitchAnimation extends StatelessWidget {

  final bool isPressed;
  final Widget newWidget;
  final Widget originalWidget;

  const SwitchAnimation({
    required this.isPressed,
    required this.newWidget,
    required this.originalWidget,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: !isPressed
          ? this.originalWidget
          : AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),
              child: this.newWidget,
            )
    );
  }
}