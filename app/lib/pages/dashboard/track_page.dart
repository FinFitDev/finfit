import 'dart:async';
import 'package:excerbuys/components/dashboard_page/track_page/workout_tracker_dashboard.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/workout_info_modal.dart';
import 'package:excerbuys/containers/dialogs/location_permission_dialog.dart';
import 'package:excerbuys/containers/map_container.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/activity/constants.dart';
import 'package:excerbuys/utils/gps/tracking_service.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final MapController _mapController = MapController();
  final WorkoutTrackingService _trackingService = WorkoutTrackingService();
  bool _isTracking = false;
  bool _isCentered = true;
  bool _isPaused = true;
  bool _isDisposed = false;
  late StreamSubscription _activePageSubscription;
  LatLng _currentPosition = LatLng(52.2297, 21.0122);
  List<Position> _trackedPositions = [];
  final ValueNotifier<int> _activeWorkoutType = ValueNotifier<int>(0);
  final ValueNotifier<int> duration = ValueNotifier<int>(0);
  final ValueNotifier<double> distance = ValueNotifier<double>(0);

  Timer? timer;

  void _toggleTrackingState() async {
    if (_isPaused) {
      // resume workout
      final permissions = await _trackingService.requestPermissions();
      if (permissions == false && mounted) {
        showDialog(
            context: context, builder: (_) => LocationPermissionDialog());
        return;
      }
      dashboardController.setTrackingPlayed(true);

      final ACTIVITY_TYPE activeType =
          AVAILABLE_WORKOUT_TYPES[_activeWorkoutType.value];
      _trackingService
          .updateDistanceInterval(TRACKING_DISTANCE_INTERVALS[activeType] ?? 2);
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        duration.value++;
      });
    } else {
      // pause workout
      dashboardController.setTrackingPlayed(false);
      timer?.cancel();
    }

    setState(() {
      _isPaused = !_isPaused;
      _isTracking = true;
    });
  }

  void _finishWorkout() async {
    timer?.cancel();
    // finish workout
    dashboardController.setTrackingPlayed(null);
    if (_trackedPositions.isNotEmpty &&
        distance.value > 5 &&
        duration.value > 5) {
      final int? id = await trainingsController.insertTraining(
          distance: distance.value,
          duration: duration.value,
          elevationChange: calcluateTotalElevationChange(_trackedPositions),
          type: AVAILABLE_WORKOUT_TYPES[_activeWorkoutType.value],
          polyline: encodePolylinePoints(_trackedPositions
              .map((el) => LatLng(el.latitude, el.longitude))
              .toList()));
      if (id != null && mounted) {
        dashboardController.setActivePage(0);
        openModal(context, WorkoutInfoModal(workoutId: id));
        duration.value = 0;
        distance.value = 0;
        setState(() {
          _isTracking = false;
          _isPaused = true;
          _trackedPositions = [];
        });
      }
    } else {
      duration.value = 0;
      distance.value = 0;
      setState(() {
        _isTracking = false;
        _isPaused = true;
        _trackedPositions = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _activePageSubscription =
        dashboardController.activePageStream.listen((activePage) async {
      if (activePage == 1) {
        setState(() {
          _isDisposed = false;
        });
        bool permissions = await _trackingService.init();
        if (!permissions && mounted) {
          showDialog(
              context: context, builder: (_) => LocationPermissionDialog());
        }
      } else if (!_isTracking && !_isDisposed) {
        _trackingService.dispose();
        setState(() {
          _isDisposed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _activePageSubscription.cancel();
    _trackingService.dispose();
    _activeWorkoutType.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        MapContainer(
          mapController: _mapController,
          trackingService: _trackingService,
          isPaused: _isPaused,
          isTracking: _isTracking,
          showPosition: true,
          setCurrentPosition: (pos) {
            setState(() {
              _currentPosition = pos;
            });
            if (_isCentered) {
              _mapController.move(
                _currentPosition,
                _mapController.camera.zoom,
              );
            }
          },
          onMapCameraPositionChanged: (camera, hasGesture) {
            if (hasGesture) {
              setState(() {
                _isCentered = false;
              });
            }
          },
          addPosition: (position) {
            if (_trackedPositions.length > 1) {
              final Position prevPos = _trackedPositions.last;
              distance.value += calculateHaversineDistance(prevPos.latitude,
                  prevPos.longitude, position.latitude, position.longitude);
            }
            setState(() {
              _trackedPositions = [..._trackedPositions, position];
            });
          },
        ),
        Positioned(
          bottom: 120,
          left: 16,
          right: 16,
          child: WorkoutTrackerDashboard(
            isTracking: _isTracking,
            isPaused: _isPaused,
            activeWorkoutIndex: _activeWorkoutType,
            availableWorkouts: AVAILABLE_WORKOUT_TYPES,
            onSelectWorkoutType: (index) {
              _activeWorkoutType.value = index;
            },
            onTogglePause: _toggleTrackingState,
            onFinishWorkout: _finishWorkout,
            distance: distance,
            duration: duration,
            rewardPoints: calculateWorkoutCalories(
              distanceMeters: distance.value,
              durationSeconds: duration.value.toDouble(),
              elevationChangeMeters:
                  calcluateTotalElevationChange(_trackedPositions),
              type: AVAILABLE_WORKOUT_TYPES[_activeWorkoutType.value],
            ).round(),
          ),
        ),
        AnimatedPositioned(
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 200),
            bottom: _isTracking ? 305 : 255,
            right: 16,
            child: RippleWrapper(
              onPressed: () {
                setState(() {
                  _isCentered = true;
                });
                _mapController.move(
                  _currentPosition,
                  _mapController.camera.zoom ?? 18,
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
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
                child: Center(
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: SvgPicture.asset(
                      'assets/svg/target.svg',
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          colors.primaryFixedDim, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
