import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/components/shared/positions/position_with_title.dart';
import 'package:excerbuys/containers/map_container.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkoutInfoModal extends StatefulWidget {
  final int workoutId;
  const WorkoutInfoModal({super.key, required this.workoutId});

  @override
  State<WorkoutInfoModal> createState() => _WorkoutInfoModalState();
}

class _WorkoutInfoModalState extends State<WorkoutInfoModal> {
  bool _error = false;
  ITrainingEntry? _workout;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    getWorkoutMetadata();
  }

  @override
  void didUpdateWidget(covariant WorkoutInfoModal oldWidget) {
    if (widget.workoutId != oldWidget.workoutId) {
      getWorkoutMetadata();
    }
    super.didUpdateWidget(oldWidget);
  }

  void openStrava() async {
    if (_workout == null || _workout?.stravaId == null) {
      throw 'Strava ID not found';
    }
    final String url = 'strava://activities/${_workout?.stravaId}';
    try {
      await launchUrl(Uri.parse(url));
    } catch (_) {
      final String webUrl =
          'https://www.strava.com/activities/${_workout?.stravaId}';
      await launchUrl(Uri.parse(webUrl));
    }
  }

  void getWorkoutMetadata() {
    final foundWorkout =
        trainingsController.userTrainings.content[widget.workoutId];
    if (foundWorkout == null) {
      setState(() {
        _error = true;
      });
      return;
    }
    setState(() {
      _workout = foundWorkout;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final activityMetadata =
        _workout != null ? getActivityMetadata(_workout!.type, colors) : null;

    return ModalContentWrapper(
      title: 'Workout details',
      onClose: () {
        closeModal(context);
      },
      child: SingleChildScrollView(
        child: _workout == null || _error || activityMetadata == null
            ? Center(
                child: Text(
                  'Workout not found.',
                  style: TextStyle(
                    color: colors.tertiaryContainer,
                    fontSize: 14,
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconContainer(
                          icon: activityMetadata.icon,
                          size: 60,
                          backgroundColor: activityMetadata.color,
                          iconColor: colors.primary,
                          borderRadius: 200,
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: [
                            Text(
                              activityMetadata.name,
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: activityMetadata.color),
                            ),
                            SizedBox(height: 8),
                            Text(
                              parseDate(_workout!.createdAt),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colors.tertiaryContainer),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_workout!.stravaId != null) ...[
                    SizedBox(height: 16),
                    RippleWrapper(
                      onPressed: openStrava,
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 255, 110, 7)
                                .withAlpha(20)),
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageComponent(
                              size: 22,
                              image:
                                  "https://images.prismic.io/sacra/9232e343-6544-430f-aacd-ca85f968ca87_strava+logo.png?auto=compress,format",
                            ),
                            SizedBox(width: 10),
                            Text(
                              'View in STRAVA',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: const Color.fromARGB(255, 255, 110, 7),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PositionWithTitle(
                            icon: 'assets/svg/clock.svg',
                            title: 'Duration',
                            value: parseDuration(_workout!.duration)),
                      ),
                      SizedBox(width: 8),
                      _workout!.distance != null
                          ? Expanded(
                              child: PositionWithTitle(
                                  icon: 'assets/svg/trend_up.svg',
                                  title: 'Distance',
                                  value: parseDistance(
                                      (_workout!.distance ?? 0).toDouble())),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  Row(
                    children: [
                      _workout!.calories != null
                          ? Expanded(
                              child: PositionWithTitle(
                                  icon: 'assets/svg/fire.svg',
                                  title: 'Calories',
                                  value: '${_workout!.calories} kcal'),
                            )
                          : SizedBox.shrink(),
                      SizedBox(width: 8),
                      Expanded(
                        child: PositionWithTitle(
                            icon: 'assets/svg/tick.svg',
                            title: 'Points earned',
                            value: '${_workout!.points} points'),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      _workout!.elevationChange != null
                          ? Expanded(
                              child: PositionWithTitle(
                                  icon: 'assets/svg/elevation.svg',
                                  title: 'Elevation',
                                  value:
                                      '${_workout!.elevationChange?.toStringAsFixed(1)} m'),
                            )
                          : SizedBox.shrink(),
                      SizedBox(width: 8),
                      _workout!.averageSpeed != null
                          ? Expanded(
                              child: PositionWithTitle(
                                  icon: 'assets/svg/speed.svg',
                                  title: 'Avg. speed',
                                  value:
                                      '${_workout!.averageSpeed?.toStringAsFixed(1)} km/h'),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  SizedBox(height: 16),
                  if (_workout!.polyline != null &&
                      _workout!.polyline!.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: colors.outline.withAlpha(100)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MapContainer(
                            mapController: _mapController,
                            polyline: _workout!.polyline,
                            polylineColor: activityMetadata.color,
                          )),
                    ),
                  ] else ...[
                    Container(
                      height: 100,
                      child: Center(
                        child: Text(
                          'No route data available',
                          style: TextStyle(
                            color: colors.tertiaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                ],
              ),
      ),
    );
  }
}
