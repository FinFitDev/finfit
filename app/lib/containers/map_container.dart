import 'dart:math';
import 'package:excerbuys/components/map/position_indicator.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/gps/tracking_service.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapContainer extends StatefulWidget {
  final MapController mapController;
  final String? polyline;
  final Color? polylineColor;
  final bool? showPosition;
  final bool? isPaused;
  final bool? isTracking;
  final void Function(Position position)? addPosition;
  final WorkoutTrackingService? trackingService;
  final void Function(LatLng pos)? setCurrentPosition;

  const MapContainer(
      {super.key,
      required this.mapController,
      this.polyline,
      this.polylineColor,
      this.showPosition,
      this.isPaused,
      this.addPosition,
      this.trackingService,
      this.setCurrentPosition,
      this.isTracking});

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  List<Position> _trackingPositions = [];
  LatLng? _currentPosition = null;
  bool _isTracking = false;

  List<LatLng> _routePoints = [];
  LatLngBounds? _routeBounds;
  bool _calculating = true;

  @override
  void initState() {
    super.initState();
    if (widget.polyline != null) {
      _decodePolyline(widget.polyline!);
    }
    if (widget.showPosition == true && widget.trackingService != null) {
      widget.trackingService!.onPositionUpdate = _handlePositionUpdate;
    }
  }

  @override
  void didUpdateWidget(covariant MapContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool stopTracking =
        (oldWidget.isPaused == null || oldWidget.isPaused == false) &&
            widget.isPaused == true;
    final bool startTracking = oldWidget.isPaused == true &&
        (widget.isPaused == false || widget.isPaused == null);

    final bool stopWorkout = oldWidget.isTracking == true &&
        (widget.isTracking == false || widget.isTracking == null);
    if (startTracking) {
      setState(() {
        _isTracking = true;
      });
    }
    if (stopTracking) {
      setState(() {
        _isTracking = false;
      });
    }

    if (stopWorkout) {
      setState(() {
        _trackingPositions = [];
      });
    }
  }

  void _handlePositionUpdate(Position position) {
    smartPrint('HANDLE POSITION UPDATE', position.latitude, position.longitude);
    if (_currentPosition == null) {
      widget.mapController.move(
        LatLng(position.latitude, position.longitude),
        widget.mapController.camera.zoom,
      );
    }
    if (!mounted) return;
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    widget.setCurrentPosition
        ?.call(LatLng(position.latitude, position.longitude));
    if (_isTracking) {
      // start collecting
      setState(() {
        _trackingPositions.add(position);
      });
      widget.addPosition?.call(position);
    }
  }

  void _decodePolyline(String polyline) {
    try {
      final points = decodePolylinePoints(polyline);
      if (!mounted) return;

      setState(() {
        _routePoints = points;
        _calculating = false;
      });

      if (points.isNotEmpty) {
        _calculateRouteBounds(points);

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
    if (!mounted) return;

    setState(() {
      _routeBounds = LatLngBounds(
        LatLng(minLat, minLng),
        LatLng(maxLat, maxLng),
      );
    });
  }

  void _fitMapToRoute() {
    if (_routeBounds == null || _routePoints.isEmpty) {
      return;
    }

    // Calculate center point
    final center = LatLng(
      (_routeBounds!.north + _routeBounds!.south) / 2,
      (_routeBounds!.east + _routeBounds!.west) / 2,
    );

    // Calculate zoom based on bounds size
    final latDiff = _routeBounds!.north - _routeBounds!.south;
    final lngDiff = _routeBounds!.east - _routeBounds!.west;
    final maxDiff = max(latDiff, lngDiff);

    double zoom;
    if (maxDiff < 0.001)
      zoom = 18.0;
    else if (maxDiff < 0.01)
      zoom = 17.0;
    else if (maxDiff < 0.1)
      zoom = 13.0;
    else if (maxDiff < 0.5)
      zoom = 11.0;
    else
      zoom = 9.0;

    Future.delayed(Duration(milliseconds: 100), () {
      widget.mapController.move(center, zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Route polyline
    List<LatLng> routePoints =
        _trackingPositions.map((p) => LatLng(p.latitude, p.longitude)).toList();

    return widget.polyline != null && _calculating
        ? UniversalLoaderBox(height: 400)
        : FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
              initialCenter: LatLng(52.2297, 21.0122),
              initialZoom: 18,
              minZoom: 8,
              maxZoom: 20,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}{r}.png',
              ),
              widget.polyline != null
                  ? PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: widget.polylineColor!,
                          strokeWidth: 4,
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              MarkerLayer(
                markers: [
                  if (_routePoints.isNotEmpty)
                    Marker(
                      point: _routePoints.first,
                      width: 14,
                      height: 14,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: widget.polylineColor),
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
                  if (_routePoints.isNotEmpty)
                    Marker(
                      point: _routePoints.last,
                      width: 14,
                      height: 14,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: widget.polylineColor),
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
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 24,
                      height: 24,
                      child: PulsingPositionIndicator(
                        position: _currentPosition,
                        color: colors.secondary,
                        size: 20,
                      ),
                    ),
                ],
              ),
              if (_trackingPositions.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: colors.secondary,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
            ],
          );
  }
}
