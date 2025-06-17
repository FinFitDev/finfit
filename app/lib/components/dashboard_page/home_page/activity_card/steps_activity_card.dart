import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:excerbuys/components/dashboard_page/home_page/activity_card/steps_graph_animation.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepsActivityCard extends StatefulWidget {
  final IStoreStepsData stepsData;
  final bool? isLoading;
  final int? daysAgo;

  const StepsActivityCard({
    super.key,
    required this.stepsData,
    this.isLoading,
    this.daysAgo,
  });

  @override
  State<StepsActivityCard> createState() => _StepsActivityCardState();
}

class _StepsActivityCardState extends State<StepsActivityCard> {
  int _totalSteps = 0;
  List<MapEntry<int, int>> _stepsData = [];

  final ValueNotifier<Map<String, int?>> trackballPositionNotifier =
      ValueNotifier({});
  bool isTrackballVisible = false;

  void updateTotalSteps() {
    setState(() {
      final DateTime key = constructDailyTimestamp(
          DateTime.now().subtract(Duration(days: widget.daysAgo ?? 0)));
      if (widget.stepsData.containsKey(key)) {
        _totalSteps =
            widget.stepsData[key]!.values.reduce((curr, next) => curr + next);
      } else {
        _totalSteps = 0;
      }
    });
  }

  void updateStepsData() {
    setState(() {
      _stepsData = widget.stepsData[constructDailyTimestamp(DateTime.now()
                  .subtract(Duration(days: widget.daysAgo ?? 0)))] !=
              null
          ? widget
              .stepsData[constructDailyTimestamp(DateTime.now()
                  .subtract(Duration(days: widget.daysAgo ?? 0)))]!
              .entries
              .toList()
          : [for (int i = 0; i < 24; i++) MapEntry(i, 0)];
    });
  }

  @override
  void initState() {
    super.initState();

    updateTotalSteps();
    updateStepsData();
  }

  @override
  void didUpdateWidget(covariant StepsActivityCard oldWidget) {
    updateTotalSteps();
    updateStepsData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final bool isToday = (widget.daysAgo ?? 0) == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                        "steps$_totalSteps $isToday"), // Unique key per widget
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        '$_totalSteps steps ${isToday ? 'today' : ''}',
                        textStyle: texts.headlineLarge,
                      )
                    ],
                  ),
                  StreamBuilder<bool>(
                      stream: dashboardController.balanceHiddenStream,
                      builder: (context, snapshot) {
                        final bool isHidden = snapshot.data ?? false;
                        return AnimatedTextKit(
                          key: ValueKey<String>(
                              "points$_totalSteps$isHidden"), // Unique key per widget
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              isHidden
                                  ? '***** finpoints'
                                  : '${calculatePointsFromSteps(_totalSteps)} finpoints',
                              textStyle: texts.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            )
                          ],
                        );
                      }),
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
        Builder(builder: (context) {
          if (widget.isLoading == true) {
            return loadingSteps(context);
          }
          if (widget.stepsData.isEmpty) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors.primaryContainer,
              ),
              margin: EdgeInsets.only(
                  left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING),
              child: StepsGraphAnimation(),
            );
          }
          return Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colors.primaryContainer,
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            margin: EdgeInsets.only(
                left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING),
            child: SfCartesianChart(
              margin: EdgeInsets.all(0),
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                labelStyle: TextStyle(color: Colors.transparent),
                isVisible: false,
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

                  if (trackballPositionNotifier.value['x'] != position['x']) {
                    triggerVibrate(FeedbackType.selection);
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
                  lineColor: colors.tertiaryContainer,
                  lineType: TrackballLineType.vertical),
              series: <ColumnSeries<MapEntry<int, int>, int>>[
                ColumnSeries<MapEntry<int, int>, int>(
                  dataSource: _stepsData,
                  animationDuration: 300,
                  xValueMapper: (MapEntry<int, int> data, _) => data.key,
                  yValueMapper: (MapEntry<int, int> data, _) => data.value,
                  color: colors.secondary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  width: 0.95,
                  borderWidth: 0,
                  borderColor: colors.secondary,
                ),
              ],
            ),
          );
        }),
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

Widget loadingSteps(BuildContext context) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(10, (index) {
          final Random random = Random();
          return random.nextInt(150) + 50;
        }).map((el) {
          return UniversalLoaderBox(
              height: el.toDouble(),
              borderRadius: 4,
              width: MediaQuery.sizeOf(context).width / 10 - 10);
        }).toList(),
      ));
}
