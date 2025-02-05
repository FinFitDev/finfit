import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card_details.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepsActivityCard extends StatefulWidget {
  final int points;
  final IStoreStepsData stepsData;

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

  void updateTotalSteps() {
    setState(() {
      final DateTime key = constructDailyTimestamp(
          DateTime.now().subtract(Duration(days: _daysAgo)));
      if (widget.stepsData.containsKey(key)) {
        _totalSteps =
            widget.stepsData[key]!.values.reduce((curr, next) => curr + next);
      } else {
        _totalSteps = 0;
      }
    });
  }

  @override
  void didUpdateWidget(covariant StepsActivityCard oldWidget) {
    updateTotalSteps();
    super.didUpdateWidget(oldWidget);
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
                updateTotalSteps();
              }, 'Today'),
              daySelector(_daysAgo == 1, colors, () {
                setState(() {
                  _daysAgo = 1;
                });
                updateTotalSteps();
              }, 'Yesterday'),
              daySelector(_daysAgo == 2, colors, () {
                setState(() {
                  _daysAgo = 2;
                });
                updateTotalSteps();
              }, getDayName(2)),
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
                  AnimatedTextKit(
                    key: ValueKey<String>(
                        "steps${_daysAgo}"), // Unique key per widget
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        '$_totalSteps steps',
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: colors.tertiary,
                        ),
                      )
                    ],
                  ),
                  AnimatedTextKit(
                    key: ValueKey<String>(
                        "points${_daysAgo}"), // Unique key per widget
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        '${_daysAgo * 17} fitness points',
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: colors.primaryFixed,
                        ),
                      )
                    ],
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
              markerSettings: TrackballMarkerSettings(
                markerVisibility:
                    TrackballVisibilityMode.visible, // Enable the dot
                shape: DataMarkerType.circle, // Change marker shape to a dot
                color: Theme.of(context).colorScheme.tertiary, // Dot color
                borderWidth: 1,
                height: 12,
                width: 12,
                borderColor: Theme.of(context)
                    .colorScheme
                    .primary, // Optional: Border color
              ),
              lineType: TrackballLineType.none,
            ),
            series: <SplineAreaSeries<MapEntry<int, int>, int>>[
              SplineAreaSeries<MapEntry<int, int>, int>(
                dataSource: widget.stepsData[constructDailyTimestamp(
                            DateTime.now()
                                .subtract(Duration(days: _daysAgo)))] !=
                        null
                    ? widget
                        .stepsData[constructDailyTimestamp(
                            DateTime.now().subtract(Duration(days: _daysAgo)))]!
                        .entries
                        .toList()
                    : [for (int i = 0; i < 24; i++) MapEntry(i, 0)],
                animationDuration: 300,
                xValueMapper: (MapEntry<int, int> data, _) => data.key,
                yValueMapper: (MapEntry<int, int> data, _) => data.value,
                gradient: LinearGradient(
                  colors: [colors.secondary, colors.primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderWidth: 4,
                borderColor: colors.secondary,
                splineType: SplineType.monotonic,
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
