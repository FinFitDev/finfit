import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/components/shared/positions/position.dart'
    as PositionComponent;
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/activity/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class WorkoutTrackerDashboard extends StatelessWidget {
  final bool isTracking;
  final bool isPaused;
  final ValueNotifier<int> activeWorkoutIndex;
  final List<ACTIVITY_TYPE> availableWorkouts;
  final void Function(int) onSelectWorkoutType;
  final VoidCallback onTogglePause;
  final VoidCallback onFinishWorkout;
  final ValueNotifier<int> duration;
  final ValueNotifier<double> distance;

  final int rewardPoints;

  const WorkoutTrackerDashboard({
    super.key,
    required this.isTracking,
    required this.isPaused,
    required this.activeWorkoutIndex,
    required this.availableWorkouts,
    required this.onSelectWorkoutType,
    required this.onTogglePause,
    required this.onFinishWorkout,
    required this.rewardPoints,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final workoutOptions = _buildWorkoutOptions(colors);

    return AnimatedContainer(
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 200),
      height: isTracking ? 170 : 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colors.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            spreadRadius: -5,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(colors),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                spacing: 40,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildLeftColumn(colors, workoutOptions),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTogglePause,
                      child: IconContainer(
                        borderRadius: 100,
                        icon: isPaused
                            ? 'assets/svg/play.svg'
                            : 'assets/svg/pause.svg',
                        size: 80,
                        iconColor: isPaused ? colors.secondary : colors.error,
                        backgroundColor:
                            (isPaused ? colors.secondary : colors.error)
                                .withAlpha(30),
                      ),
                    ),
                  ),
                  Expanded(
                      child: ValueListenableBuilder<int>(
                          valueListenable: duration,
                          builder: (context, value, _) {
                            return _buildMetricColumn(
                              colors,
                              label: 'Duration',
                              value: parseDuration(duration.value),
                            );
                          })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(
      ColorScheme colors, List<WorkoutType> workoutOptions) {
    if (!isTracking) {
      return DropdownTrigger<WorkoutType>(
        onSelect: onSelectWorkoutType,
        options: workoutOptions,
        optionDisplay: (WorkoutType workoutType, void Function() onSelect) {
          return PositionComponent.Position(
            onPress: onSelect,
            optionName: workoutType.name.value,
            icon: workoutType.icon,
            isSelected:
                workoutType.name == availableWorkouts[activeWorkoutIndex.value],
          );
        },
        renderChild: (WorkoutType workoutType) {
          return Column(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconContainer(
                borderRadius: 100,
                icon: workoutType.icon,
                size: 50,
                iconColor: colors.secondary,
                backgroundColor: colors.secondary.withAlpha(30),
              ),
              Text(
                workoutType.name.value.toString(),
                style: TextStyle(
                  color: colors.tertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        },
        activeOptionIndex: activeWorkoutIndex,
      );
    }

    if (isPaused) {
      return StreamBuilder<bool>(
          stream: trainingsController.isInsertingStream,
          builder: (context, snapshot) {
            return RippleWrapper(
              onPressed: () {
                if (snapshot.data == true) {
                  return;
                }
                onFinishWorkout();
              },
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconContainer(
                    borderRadius: 100,
                    icon: 'assets/svg/stop.svg',
                    size: 50,
                    iconColor: colors.error,
                    backgroundColor: colors.error.withAlpha(30),
                    isLoading: snapshot.data == true,
                  ),
                  Text(
                    'Finish',
                    style: TextStyle(
                      color: colors.tertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return ValueListenableBuilder<double>(
        valueListenable: distance,
        builder: (context, value, _) {
          return _buildMetricColumn(
            colors,
            label: 'Distance',
            value: parseDistance(distance.value),
          );
        });
  }

  Widget _buildMetricColumn(ColorScheme colors,
      {required String label, required String value}) {
    return Column(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: colors.tertiary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: colors.tertiary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colors) {
    return ValueListenableBuilder<int>(
      valueListenable: activeWorkoutIndex,
      builder: (context, activeIndex, _) {
        final workoutLabel = availableWorkouts[activeIndex].value;
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: colors.tertiaryContainer.withAlpha(40),
          ),
          height: isTracking ? 45 : 0,
          child: Row(
            spacing: 16,
            children: [
              Text(
                workoutLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colors.tertiary,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors.secondary.withAlpha(20),
                ),
                child: Text(
                  '$rewardPoints points',
                  style: TextStyle(
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<WorkoutType> _buildWorkoutOptions(ColorScheme colors) {
    return availableWorkouts
        .map(
          (activity) => WorkoutType(
            name: activity,
            icon: getActivityMetadata(activity, colors).icon,
          ),
        )
        .toList();
  }
}
