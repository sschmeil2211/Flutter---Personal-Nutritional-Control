import 'package:flutter/material.dart';

class ArcProgressIndicatorData {
  ArcProgressIndicatorData(this.x, this.y);

  final String? x;
  final int? y;
}

class MacronutrientsIndicatorData {
  MacronutrientsIndicatorData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}