import 'dart:math';

import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card_details.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepsActivityCard extends StatefulWidget {
  final int points;
  final Map<int, int> stepsData;

  const StepsActivityCard({
    super.key,
    required this.points,
    required this.stepsData,
  });

  @override
  State<StepsActivityCard> createState() => _StepsActivityCardState();
}

class _StepsActivityCardState extends State<StepsActivityCard> {
  int _totalSteps = 0;
  int _daysAgo = 0;
  @override
  void didUpdateWidget(covariant StepsActivityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _totalSteps = widget.stepsData.values.reduce((curr, next) => curr + next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = colors.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.primaryContainer,
          ),
          height: 45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              daySelector(_daysAgo == 0, colors, () {
                setState(() {
                  _daysAgo = 0;
                });
              }, 'Today'),
              daySelector(_daysAgo == 1, colors, () {
                setState(() {
                  _daysAgo = 1;
                });
              }, 'Yesterday'),
              daySelector(_daysAgo == 2, colors, () {
                setState(() {
                  _daysAgo = 2;
                });
              }, 'Friday'),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 3 * HORIZOTAL_PADDING, top: 30),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12145 steps',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colors.tertiary,
                    ),
                  ),
                  Text(
                    '127 fitness points',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: colors.primaryFixed,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 200,
          child: SfCartesianChart(
            margin: EdgeInsets.all(0),
            plotAreaBorderWidth: 0,
            primaryXAxis: NumericAxis(
              isVisible: false,
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(width: 0),
              isVisible: false,
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.longPress,
              tooltipSettings: InteractiveTooltip(
                color: Theme.of(context).colorScheme.tertiary,
                format: 'Hour: point.x\nSteps: point.y',
              ),
            ),
            series: <SplineAreaSeries<MapEntry<int, int>, int>>[
              SplineAreaSeries<MapEntry<int, int>, int>(
                dataSource: [
                  MapEntry(0, 158),
                  MapEntry(1, 160),
                  MapEntry(2, 192),
                  MapEntry(3, 162),
                  MapEntry(4, 192),
                  MapEntry(5, 135),
                  MapEntry(6, 153),
                  MapEntry(7, 142),
                  MapEntry(8, 180),
                  MapEntry(9, 150),
                  MapEntry(10, 143),
                  MapEntry(11, 147),
                  MapEntry(12, 149),
                  MapEntry(13, 140),
                  MapEntry(14, 146),
                  MapEntry(15, 148),
                  MapEntry(16, 121),
                  MapEntry(17, 186),
                  MapEntry(18, 180),
                  MapEntry(19, 162),
                  MapEntry(20, 161),
                  MapEntry(21, 150),
                  MapEntry(22, 137),
                  MapEntry(23, 178)
                ],
                xValueMapper: (MapEntry<int, int> data, _) => data.key,
                yValueMapper: (MapEntry<int, int> data, _) => data.value,
                gradient: LinearGradient(
                  colors: [colors.secondary, colors.primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderWidth: 4,
                borderColor: colors.secondary,
                splineType: SplineType.cardinal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget daySelector(
    bool isActive, ColorScheme colors, void Function() onPressed, String day) {
  return Expanded(
      child: GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? colors.secondary : Colors.transparent),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
              fontSize: 13,
              color: isActive ? colors.primary : colors.primaryFixedDim,
              fontWeight: FontWeight.w600),
        ),
      ),
    ),
  ));
}
