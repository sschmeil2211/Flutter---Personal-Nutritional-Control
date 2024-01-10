// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class CalendarPicker extends StatelessWidget {
  final String day;
  final Function() onPressed;

  const CalendarPicker({
    required this.day,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          color: Colors.transparent,
          elevation: 0,
          minWidth: 50,
          padding: const EdgeInsets.all(10),
          onPressed: this.onPressed,
          child: Text(
            this.day,
            style: const TextStyle(fontSize: 20),
          )
        ),
      ],
    );
  }
}