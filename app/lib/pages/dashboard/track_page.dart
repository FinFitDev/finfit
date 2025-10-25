import 'dart:async';
import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/containers/map_container.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/activity/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/gps/tracking_service.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:excerbuys/components/shared/positions/position.dart'
    as PositionComponent;

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final MapController _mapController = MapController();
  final WorkoutTrackingService _trackingService = WorkoutTrackingService();
  bool _isTracking = false;
  bool _isPaused = true;
  late StreamSubscription _activePageSubscription;
  LatLng _currentPosition = LatLng(52.2297, 21.0122);
  List<Position> _trackedPositions = [];
  final ValueNotifier<int> _activeWorkoutType = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();

    _activePageSubscription =
        dashboardController.activePageStream.listen((activePage) {
      if (activePage == 1) {
        _trackingService.init();
      } else if (!_isTracking) {
        _trackingService.dispose();
      }
    });
  }

  @override
  void dispose() {
    _activePageSubscription.cancel();
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
          showPosition: true,
          setCurrentPosition: (pos) {
            setState(() {
              _currentPosition = pos;
            });
          },
          addPosition: (position) {
            setState(() {
              _trackedPositions = [..._trackedPositions, position];
            });
          },
        ),
        Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: Container(
              height: _isTracking ? 170 : 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colors.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    spreadRadius: -5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _isTracking
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            color: colors.tertiaryContainer.withAlpha(40),
                          ),
                          height: 45,
                          child: Row(spacing: 16, children: [
                            Text(
                                AVAILABLE_WORKOUT_TYPES[
                                        _activeWorkoutType.value]
                                    .value,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: colors.tertiary,
                                    fontSize: 16)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: colors.secondary.withAlpha(20),
                              ),
                              child: Text(
                                '134 points',
                                style: TextStyle(
                                    color: colors.secondary,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        spacing: 40,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isTracking
                              ? _isPaused
                                  ? Expanded(
                                      child: RippleWrapper(
                                        onPressed: () {
                                          setState(() {
                                            _isTracking = false;
                                          });
                                          smartPrint(
                                              'FINISHED', _trackedPositions);
                                        },
                                        child: Column(
                                          spacing: 4,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconContainer(
                                              borderRadius: 100,
                                              icon: 'assets/svg/stop.svg',
                                              size: 50,
                                              iconColor: colors.error,
                                              backgroundColor:
                                                  colors.error.withAlpha(30),
                                            ),
                                            Text(
                                              'Finish',
                                              style: TextStyle(
                                                  color: colors.tertiary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Column(
                                        spacing: 4,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '0.00 km',
                                            style: TextStyle(
                                                color: colors.tertiary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Distance',
                                            style: TextStyle(
                                                color: colors.tertiary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    )
                              : Expanded(
                                  child: DropdownTrigger<WorkoutType>(
                                      onSelect: (int wt) {
                                        _activeWorkoutType.value = wt;
                                      },
                                      options:
                                          AVAILABLE_WORKOUT_TYPES.map((el) {
                                        return WorkoutType(
                                            name: el,
                                            icon:
                                                getActivityMetadata(el, colors)
                                                    .icon);
                                      }).toList(),
                                      optionDisplay: (WorkoutType wt,
                                          void Function() onSelect) {
                                        return PositionComponent.Position(
                                            onPress: onSelect,
                                            optionName: wt.name.value,
                                            icon: wt.icon,
                                            isSelected: wt.name ==
                                                AVAILABLE_WORKOUT_TYPES[
                                                    _activeWorkoutType.value]);
                                      },
                                      renderChild: (WorkoutType wt) {
                                        return Column(
                                          spacing: 4,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconContainer(
                                              borderRadius: 100,
                                              icon: wt.icon,
                                              size: 50,
                                              iconColor: colors.secondary,
                                              backgroundColor: colors.secondary
                                                  .withAlpha(30),
                                            ),
                                            Text(
                                              wt.name.value.toString(),
                                              style: TextStyle(
                                                  color: colors.tertiary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        );
                                      },
                                      activeOptionIndex: _activeWorkoutType)),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPaused = !_isPaused;
                                  _isTracking = true;
                                });
                              },
                              child: IconContainer(
                                borderRadius: 100,
                                icon: !_isPaused
                                    ? 'assets/svg/pause.svg'
                                    : 'assets/svg/play.svg',
                                size: 80,
                                iconColor:
                                    _isPaused ? colors.secondary : colors.error,
                                backgroundColor: _isPaused
                                    ? colors.secondary.withAlpha(30)
                                    : colors.error.withAlpha(30),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 4,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '00:00',
                                  style: TextStyle(
                                      color: colors.tertiary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Duration',
                                  style: TextStyle(
                                      color: colors.tertiary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
            bottom: _isTracking ? 305 : 255,
            right: 16,
            child: RippleWrapper(
              onPressed: () {
                _mapController.move(
                  _currentPosition,
                  18,
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
                      color: Colors.black.withAlpha(50),
                      spreadRadius: -5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/target.svg',
                    width: 30,
                    colorFilter: ColorFilter.mode(
                        colors.primaryFixedDim, BlendMode.srcIn),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
