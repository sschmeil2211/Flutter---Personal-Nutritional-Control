// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

SnackBar customSnackBar(String message, Color backgroundColor) => SnackBar(
  duration: const Duration(seconds: 3),
  backgroundColor: backgroundColor,
  content: Row(
    children: [
      const Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.close)
      ),
      Expanded(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  ),
);