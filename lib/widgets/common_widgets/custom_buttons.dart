// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';

class ButtonIndicator extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Function() onPressed;

  const ButtonIndicator({
    required this.isLoading,
    required this.onPressed,
    required this.label,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    if(this.isLoading)
      return const CircularProgressIndicator();
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: this.onPressed,
          child: Text(this.label),
        )
    );
  }
}
