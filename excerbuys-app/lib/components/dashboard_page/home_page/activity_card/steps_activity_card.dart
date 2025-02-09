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
  final ValueNotifier<Map<String, int?>> trackballPositionNotifier =
      ValueNotifier({});
  bool isTrackballVisible = false;

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
  void initState() {
    updateTotalSteps();
    super.initState();
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
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: colors.primaryContainer.withAlpha(150),
        //   ),
        //   height: 45,
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: [
        //       daySelector(_daysAgo == 0, colors, () {
        //         setState(() {
        //           _daysAgo = 0;
        //         });
        //         updateTotalSteps();
        //       }, 'Today'),
        //       daySelector(_daysAgo == 1, colors, () {
        //         setState(() {
        //           _daysAgo = 1;
        //         });
        //         updateTotalSteps();
        //       }, 'Yesterday'),
        //       daySelector(_daysAgo == 2, colors, () {
        //         setState(() {
        //           _daysAgo = 2;
        //         });
        //         updateTotalSteps();
        //       }, getDayName(2)),
        //     ],
        //   ),
        // ),
        Container(
          height: 55,
          margin: EdgeInsets.only(
              left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    key: ValueKey<String>(
                        "steps${_totalSteps}"), // Unique key per widget
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        '$_totalSteps steps today',
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
                        "points${_totalSteps}"), // Unique key per widget
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        '${(_totalSteps * 0.2).round()} points',
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: colors.primaryFixed,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              ValueListenableBuilder(
                  valueListenable: trackballPositionNotifier,
                  builder: (context, value, child) {
                    return value['x'] != null &&
                            value['y'] != null &&
                            isTrackballVisible == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${value['y'].toString()} steps',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colors.secondary),
                              ),
                              Text(
                                convertHourAmPm(value['x']!),
                                style: TextStyle(
                                  color:
                                      colors.tertiaryContainer.withAlpha(150),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink();
                  })
            ],
          ),
        ),
        Container(
          height: 200,
          margin: EdgeInsets.only(top: 10),
          child: SfCartesianChart(
            margin: EdgeInsets.all(0),
            plotAreaBorderWidth: 0,
            primaryXAxis: NumericAxis(
              labelStyle: TextStyle(color: Colors.transparent),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(width: 0),
              isVisible: false,
            ),
            onTrackballPositionChanging: (trackballArgs) {
              final point = trackballArgs.chartPointInfo.chartPoint;
              if (point != null) {
                final position = {
                  'x': point.x as int,
                  'y': (point.y ?? 0) as int
                };

                if (trackballPositionNotifier.value != position) {
                  trackballPositionNotifier.value = position;
                }
              }
            },
            onChartTouchInteractionDown: (tapArgs) {
              setState(() {
                isTrackballVisible = true;
              });
            },
            onChartTouchInteractionUp: (tapArgs) {
              setState(() {
                isTrackballVisible = false;
                trackballPositionNotifier.value = {'x': null, 'y': null};
              });
            },
            trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.longPress,
                tooltipSettings: InteractiveTooltip(
                  enable: false,
                ),
                markerSettings: TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.hidden,
                ),
                lineType: TrackballLineType.vertical),
            series: <ColumnSeries<MapEntry<int, int>, int>>[
              ColumnSeries<MapEntry<int, int>, int>(
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
                color: colors.secondary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                width: 0.95,
                borderWidth: 0,
                borderColor: colors.secondary,
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
