// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/DayModel.dart';
import 'package:personal_nutrition_control/models/UserModel.dart';
import 'package:personal_nutrition_control/providers/DayProvider.dart';
import 'package:personal_nutrition_control/providers/UserProvider.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class DiaryIndicators extends StatefulWidget {
  const DiaryIndicators({super.key});

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
    return Consumer<DayProvider>(
      builder: (context, dayProvider, child){
        UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
        DayModel? actualDay = dayProvider.actualDay;
        if(user == null || actualDay == null)
          return Container();

        DateTime now = DateTime.now();
        final DayModel? day = dayProvider.days.firstWhere((d) => d!.date.contains('${now.year}-${now.month}-${now.day}'));

        if (day == null)
          return Text('Día no encontrado');
        // Actualiza tu interfaz de usuario con los datos del día específico
        return Row(
          children: [
            CaloriesIndicator(
              tooltipBehavior: _proteinsTooltipBehavior,
              actualValue: day.caloriesConsumed.toInt(),
              maximumValue: user.targetCalories,
              size: 200,
            ),
            MacronutrientsIndicator(
              tooltipBehavior: _macrosTooltipBehavior,
              totalProteins: day.proteinsConsumed,
              totalCarbs: day.carbsConsumed,
              totalFats: day.fatsConsumed,
            )
          ],
        );
      },
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
        series: <CircularSeries>[
          RadialBarSeries<ArcProgressIndicatorData, String>(
            dataSource: [ ArcProgressIndicatorData("Calories", this.actualValue ) ],
            xValueMapper: (data, _) => data.x,
            yValueMapper: (data, _) => data.y,
            pointColorMapper: (data, _) => Colors.deepOrangeAccent,
            innerRadius: '65%',
            trackOpacity: 0.1,
            cornerStyle: CornerStyle.bothCurve,
            maximumValue: this.maximumValue.toDouble(),
          ),
        ],
        tooltipBehavior: this.tooltipBehavior,
        annotations: [
          CircularChartAnnotation(
              widget: Text('Proteins')
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
  final TooltipBehavior tooltipBehavior;

  const MacronutrientsIndicator({
    required this.totalProteins,
    required this.totalFats,
    required this.totalCarbs,
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
        height: 200,
        width: 200,
        child: SfCircularChart(
          tooltipBehavior: this.tooltipBehavior,
          series: <PieSeries<MacronutrientsIndicatorData, String>>[
            PieSeries<MacronutrientsIndicatorData, String>(
              pointColorMapper:(data,  _) => data.color,
              xValueMapper: (data, _) => data.x,
              yValueMapper: (data, _) => data.y,
              dataLabelMapper: (data, _) => data.x,
              dataSource: chartData,
              dataLabelSettings: const DataLabelSettings(
                connectorLineSettings: ConnectorLineSettings(
                  length: '15',
                  type: ConnectorType.curve
                ),
                isVisible: true,
              ),
            ),
          ],
        )
    );
  }
}

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