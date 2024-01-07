// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/DashboardModels.dart';
import 'package:personal_nutrition_control/models/DayModel.dart';
import 'package:personal_nutrition_control/providers/UserProvider.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class DiaryIndicators extends StatefulWidget {
  final DayModel dayToView;

  const DiaryIndicators({
    required this.dayToView,
    super.key
  });

  @override
  State<DiaryIndicators> createState() => _DiaryIndicatorsState();
}

class _DiaryIndicatorsState extends State<DiaryIndicators> {

  late TooltipBehavior _macrosTooltipBehavior;
  late TooltipBehavior _proteinsTooltipBehavior;

  @override
  void initState(){
    _macrosTooltipBehavior = TooltipBehavior(enable: true);
    _proteinsTooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int targetCalories = Provider.of<UserProvider>(context, listen: false).user?.targetCalories ?? 2000;
    double size = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CaloriesIndicator(
          tooltipBehavior: _proteinsTooltipBehavior,
          actualValue: widget.dayToView.caloriesConsumed.toInt(),
          maximumValue: targetCalories,
          size: size * 0.2,
        ),
        MacronutrientsIndicator(
          size: size * 0.2,
          tooltipBehavior: _macrosTooltipBehavior,
          totalProteins: widget.dayToView.proteinsConsumed,
          totalCarbs: widget.dayToView.carbsConsumed,
          totalFats: widget.dayToView.fatsConsumed,
        )
      ],
    );
  }
}

class CaloriesIndicator extends StatelessWidget {

  final double size;
  final int maximumValue;
  final int actualValue;
  final TooltipBehavior tooltipBehavior;

  const CaloriesIndicator({
    required this.size,
    required this.maximumValue,
    required this.actualValue,
    required this.tooltipBehavior,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: this.size,
      width: this.size,
      child: SfCircularChart(
        margin: EdgeInsets.all(0),
        series: <CircularSeries>[
          RadialBarSeries<ArcProgressIndicatorData, String>(
            xValueMapper: (data, _) => data.x,
            yValueMapper: (data, _) => data.y,
            pointColorMapper: (data, _) => Colors.deepOrangeAccent,
            innerRadius: '65%',
            trackOpacity: 0.1,
            cornerStyle: CornerStyle.bothCurve,
            maximumValue: this.maximumValue.toDouble(),
            dataSource: [
              ArcProgressIndicatorData("Calories", this.actualValue )
            ],
          ),
        ],
        tooltipBehavior: this.tooltipBehavior,
        annotations: [
          CircularChartAnnotation(
            widget: const Text('Proteins')
          )
        ],
      ),
    );
  }
}

class MacronutrientsIndicator extends StatelessWidget {

  final double totalProteins;
  final double totalFats;
  final double totalCarbs;
  final double size;
  final TooltipBehavior tooltipBehavior;

  const MacronutrientsIndicator({
    required this.totalProteins,
    required this.totalFats,
    required this.totalCarbs,
    required this.size,
    required this.tooltipBehavior,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final double totalMacros = totalProteins + totalCarbs + totalFats;

    final double proteinsPercentage = (this.totalProteins.toDouble() * 100 / totalMacros);
    final double carbsPercentage = (this.totalCarbs.toDouble() * 100 / totalMacros);
    final double fatsPercentage = (this.totalFats.toDouble() * 100 / totalMacros);

    final List<MacronutrientsIndicatorData> chartData = [
      MacronutrientsIndicatorData('Protein', proteinsPercentage, Colors.lightBlue),
      MacronutrientsIndicatorData('Fats', carbsPercentage, Colors.yellowAccent),
      MacronutrientsIndicatorData('Carbs', fatsPercentage, Colors.lightGreen),
    ];

    return SizedBox(
      height: this.size,
      width: this.size,
      child: SfCircularChart(

        margin: EdgeInsets.all(0),
        tooltipBehavior: this.tooltipBehavior,
        series: <PieSeries<MacronutrientsIndicatorData, String>>[
          PieSeries<MacronutrientsIndicatorData, String>(
            pointColorMapper:(data,  _) => data.color,
            xValueMapper: (data, _) => data.x,
            yValueMapper: (data, _) => data.y,
            dataLabelMapper: (data, _) => data.x,
            dataSource: chartData,
            dataLabelSettings: const DataLabelSettings(
              connectorLineSettings: ConnectorLineSettings(length: '15', type: ConnectorType.curve),
              isVisible: true,
            ),
          ),
        ],
      )
    );
  }
}