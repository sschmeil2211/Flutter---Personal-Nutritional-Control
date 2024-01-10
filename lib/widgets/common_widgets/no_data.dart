// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String label;

  const NoData({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.report_problem_outlined, color: Colors.white24, size: 50),
        Text(this.label, style: const TextStyle(color: Colors.white24))
      ],
    );
  }
}