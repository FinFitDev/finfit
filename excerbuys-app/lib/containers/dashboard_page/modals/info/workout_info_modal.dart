import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:share_plus/share_plus.dart';

class WorkoutInfoModal extends StatefulWidget {
  final String workoutId;
  const WorkoutInfoModal({super.key, required this.workoutId});

  @override
  State<WorkoutInfoModal> createState() => _WorkoutInfoModalState();
}

class _WorkoutInfoModalState extends State<WorkoutInfoModal> {
  bool _error = false;
  ITrainingEntry? _workout;
  int _daysAgo = 0;
  ActivityMetadata? _activityMetadata;

  void getWorkoutMetadata() {
    final foundWorkout =
        trainingsController.userTrainings.content[widget.workoutId];
    if (foundWorkout == null) {
      setState(() {
        _error = true;
      });
      return;
    }
    final now = DateTime.now();
    setState(() {
      _daysAgo = DateTime(now.year, now.month, now.day)
          .difference(DateTime(foundWorkout.createdAt.year,
              foundWorkout.createdAt.month, foundWorkout.createdAt.day))
          .inDays;
      _workout = foundWorkout;
    });

    final activityMetadata = getActivityMetadata(parseActivityType(
        HealthWorkoutActivityType.values
            .firstWhere((el) => el.name == foundWorkout.type)));

    setState(() {
      _activityMetadata = activityMetadata;
    });
  }

  @override
  void initState() {
    getWorkoutMetadata();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkoutInfoModal oldWidget) {
    if (widget.workoutId != oldWidget.workoutId) {
      getWorkoutMetadata();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjust with keyboard
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MODAL_BORDER_RADIUS),
              topRight: Radius.circular(MODAL_BORDER_RADIUS)),
          child: Container(
              color: colors.primary,
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: HORIZOTAL_PADDING,
                  left: HORIZOTAL_PADDING,
                  right: HORIZOTAL_PADDING,
                  bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
              child: _error
                  ? emptyMetadata(colors, texts)
                  : Wrap(
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        Row(
                          children: [
                            ActivityIcon(
                                icon: _activityMetadata!.icon, size: 80),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _activityMetadata!.name,
                                  textAlign: TextAlign.start,
                                  style: texts.headlineLarge
                                      ?.copyWith(color: colors.secondary),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getDayName(_daysAgo)}, ${getDayNumber(_daysAgo)} ${getDayMonth(_daysAgo)} ${getDayYear(_daysAgo)}',
                                  textAlign: TextAlign.left,
                                  style: texts.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: colors.tertiaryContainer),
                                ),
                              ],
                            ))
                          ],
                        ),
                        ListComponent(
                          data: {
                            'Started at':
                                '${_workout!.createdAt.hour}:${_workout!.createdAt.minute.toString().padLeft(2, '0')}',
                            'Calories burnt':
                                '${formatNumber(_workout!.calories ?? 0)} kcal',
                            'Duration': parseDuration(_workout!.duration),
                            'Distance': parseDistance(
                                (_workout!.distance ?? 0).toDouble()),
                          },
                          summary:
                              '${formatNumber(_workout!.points)} finpoints',
                        ),
                        // MainButton(
                        //     label: 'Share',
                        //     backgroundColor: colors.secondary,
                        //     textColor: colors.primary,
                        //     onPressed: () {
                        //       Share.share(
                        //           "Check out my workout session on ${getDayName(_daysAgo)}, ${getDayNumber(_daysAgo)} ${getDayMonth(_daysAgo)} ${getDayYear(_daysAgo)}!");
                        //     })
                      ],
                    ))),
    );
  }
}

Widget emptyMetadata(ColorScheme colors, TextTheme texts) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Text(
          "Couldn't find workout data",
          textAlign: TextAlign.start,
          style: texts.headlineLarge,
        ),
      ),
      Text(
        textAlign: TextAlign.start,
        "Close the modal adn try again",
        style: TextStyle(
          color: colors.primaryFixedDim,
        ),
      ),
    ],
  );
}
