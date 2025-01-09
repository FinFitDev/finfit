import 'dart:math';

import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card_details.dart';
import 'package:excerbuys/types/general.dart';
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

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                child: SvgPicture.asset('assets/svg/walking.svg',
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, right: 12),
                height: 36,
                width: 1,
                color: color,
              ),
              Container(
                margin: EdgeInsets.only(right: 6),
                child: Text(
                  widget.points.abs().toString(),
                  style: TextStyle(
                      color: color, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '($_totalSteps passive steps today)',
                style: TextStyle(color: colors.tertiaryContainer, fontSize: 12),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 160,
            child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  interval: 4,
                  majorGridLines: MajorGridLines(width: 0, dashArray: [
                    4,
                  ]),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  majorGridLines: MajorGridLines(width: 0),
                  opposedPosition: true,
                  isVisible: false,
                ),
                trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.longPress,
                    tooltipSettings: InteractiveTooltip(
                        color: colors.primary,
                        format: 'Hour: point.x\nSteps: point.y')),
                series: <ColumnSeries<MapEntry<int, int>, int>>[
                  ColumnSeries<MapEntry<int, int>, int>(
                      dataSource: <MapEntry<int, int>>[
                        ...widget.stepsData.entries
                      ],
                      color: colors.secondary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3)),
                      xValueMapper: (MapEntry<int, int> data, _) => data.key,
                      yValueMapper: (MapEntry<int, int> data, _) => data.value),
                ]),
          ),
          Text(
            'Shows activity not related to any user induced training session.',
            style: TextStyle(fontSize: 10, color: colors.tertiaryContainer),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
