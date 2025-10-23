import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/indicators/labels/empty_data_modal.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/components/shared/positions/position_with_title.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:health/health.dart';
import 'package:share_plus/share_plus.dart';
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
  List<LatLng> _routePoints = [];
  LatLngBounds? _routeBounds;

  void openStrava() async {
    if (_workout == null || _workout?.stravaId == null) {
      throw 'Strava ID not found';
    }
    final String url = 'strava://activities/${_workout?.stravaId}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Fallback to web
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

    // Decode polyline if available
    if (foundWorkout.polyline != null && foundWorkout.polyline!.isNotEmpty) {
      _decodePolyline(foundWorkout.polyline!);
    }
  }

  void _decodePolyline(String polyline) {
    try {
      final points = _decodePolylinePoints(polyline);
      setState(() {
        _routePoints = points;
      });

      // Calculate bounds for the route
      if (points.isNotEmpty) {
        _calculateRouteBounds(points);

        // Set initial camera position to show entire route
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fitMapToRoute();
        });
      }
    } catch (e) {
      print('Error decoding polyline: $e');
    }
  }

  void _calculateRouteBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    setState(() {
      _routeBounds = LatLngBounds(
        LatLng(minLat, minLng),
        LatLng(maxLat, maxLng),
      );
    });
  }

  void _fitMapToRoute() {
    if (_routeBounds == null || _routePoints.isEmpty) return;

    // Calculate center point
    final center = LatLng(
      (_routeBounds!.north + _routeBounds!.south) / 2,
      (_routeBounds!.east + _routeBounds!.west) / 2,
    );

    // Calculate approximate zoom level based on bounds
    final latDiff = _routeBounds!.north - _routeBounds!.south;
    final lngDiff = _routeBounds!.east - _routeBounds!.west;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    // Adjust zoom based on the size of the route
    double zoom = 15.0;
    if (maxDiff > 0.1) zoom = 12.0;
    if (maxDiff > 0.5) zoom = 10.0;
    if (maxDiff > 1.0) zoom = 8.0;

    _mapController.move(center, zoom);
  }

  List<LatLng> _decodePolylinePoints(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
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
                      Expanded(
                        child: PositionWithTitle(
                            icon: 'assets/svg/trend_up.svg',
                            title: 'Distance',
                            value: parseDistance(
                                (_workout!.distance ?? 0).toDouble())),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PositionWithTitle(
                            icon: 'assets/svg/fire.svg',
                            title: 'Calories',
                            value: '${_workout!.calories} kcal'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: PositionWithTitle(
                            icon: 'assets/svg/tick.svg',
                            title: 'Points earned',
                            value: '${_workout!.points} points'),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  if (_routePoints.isNotEmpty) ...[
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
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _routePoints.isNotEmpty
                                ? _routePoints.first
                                : LatLng(0, 0),
                            initialZoom: 10.0,
                            interactionOptions: const InteractionOptions(
                              flags:
                                  InteractiveFlag.all & ~InteractiveFlag.rotate,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}{r}.png',
                              userAgentPackageName: 'com.excerbuys.app',
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _routePoints,
                                  color: activityMetadata.color,
                                  strokeWidth: 4,
                                ),
                              ],
                            ),
                            if (_routePoints.isNotEmpty)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _routePoints.first,
                                    width: 14,
                                    height: 14,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: activityMetadata.color),
                                      child: Center(
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                              color: colors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Marker(
                                    point: _routePoints.last,
                                    width: 14,
                                    height: 14,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: activityMetadata.color),
                                      width: 6,
                                      height: 6,
                                      child: Center(
                                        child: Text(
                                          '2',
                                          style: TextStyle(
                                              color: colors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (_workout!.polyline != null &&
                      _workout!.polyline!.isNotEmpty) ...[
                    Container(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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
