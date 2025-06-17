import 'dart:async';

import 'package:excerbuys/store/controllers/app_controller/app_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapHandler extends StatefulWidget {
  final MapController mapController;
  final void Function(LatLng pos)? onLocalize;
  final void Function()? onInit;
  final void Function(MapCamera pos, bool hasGesture)? onMapMoved;
  final List<Marker> markers;
  final Widget Function(BuildContext context, List<Marker> markers)
      aggregateMarkerBuilder;
  final void Function(TapPosition tapPosition, LatLng point)? onTap;
  const MapHandler(
      {super.key,
      this.onInit,
      this.onMapMoved,
      required this.markers,
      this.onTap,
      required this.aggregateMarkerBuilder,
      required this.mapController,
      this.onLocalize});

  @override
  State<MapHandler> createState() => _MapHandlerState();
}

class _MapHandlerState extends State<MapHandler> {
  LatLng? myLocation;
  StreamSubscription<Position?>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    appController.getCurrentLocation();
    widget.onInit?.call();
    _locationSubscription =
        appController.currentLocationStream.listen((location) {
      if (location != null) {
        final newLatLng = LatLng(location.latitude, location.longitude);
        setState(() {
          myLocation = newLatLng;
        });
        widget.onLocalize?.call(newLatLng);
        // TODO: Uncomment the line below to move the map to the user's location
        // widget.mapController.move(newLatLng, _mapController.camera.zoom);
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
          onPositionChanged: widget.onMapMoved,
          onTap: (position, latlng) {
            FocusScope.of(context).unfocus();
            widget.onTap?.call(position, latlng);
          },
          initialCenter: WARSAW_COORDINATES,
          initialZoom: 10),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(markers: [
          if (myLocation != null)
            Marker(
              width: 60,
              height: 60,
              point: myLocation!,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.4),
                    ),
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
            ),
        ]),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 100,
            size: const Size(50, 50),
            alignment: Alignment.center,
            showPolygon: false,
            padding: const EdgeInsets.all(50),
            maxZoom: 15,
            markers: widget.markers,
            builder: widget.aggregateMarkerBuilder,
          ),
        ),
      ],
    );
  }
}
