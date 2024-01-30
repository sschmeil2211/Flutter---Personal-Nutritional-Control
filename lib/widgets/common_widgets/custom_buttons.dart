// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';

class ButtonWithLoading extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Function() onPressed;

  const ButtonWithLoading({
    required this.isLoading,
    required this.onPressed,
    required this.label,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: this.onPressed,
        child: this.isLoading
            ? ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 20, minWidth: 20,
                  maxHeight: 20, minHeight: 20
                ),
                child: const CircularProgressIndicator()
              )
            : Text(this.label),
      ),
    );
  }
}
