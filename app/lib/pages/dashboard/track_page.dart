import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/activity/strava_controller/strava_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final MapController _mapController = MapController();
  final List<Position> _positions = [];

  @override
  void initState() {
    super.initState();
    // _startTracking();
  }

  // Future<void> _startTracking() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) return Future.error('Location services are disabled');

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   Geolocator.getPositionStream(
  //     locationSettings: LocationSettings(
  //       accuracy: LocationAccuracy.best,
  //       distanceFilter: 5,
  //     ),
  //   ).listen((Position position) {
  //     print(position);
  //     setState(() {
  //       _positions.add(position);
  //     });

  //     // Move map to latest position
  //     if (_positions.isNotEmpty) {
  //       _mapController.move(
  //         LatLng(position.latitude, position.longitude),
  //         16.0, // fixed zoom
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Latest position marker
    // LatLng? latestPosition = _positions.isNotEmpty
    //     ? LatLng(_positions.last.latitude, _positions.last.longitude)
    //     : null;

    // // Route polyline
    // List<LatLng> routePoints =
    //     _positions.map((p) => LatLng(p.latitude, p.longitude)).toList();

    return Container(
      margin: EdgeInsets.only(top: 200),
      child: MainButton(
          label: 'Authorize strava',
          backgroundColor: colors.secondary,
          textColor: colors.primary,
          onPressed: () {
            stravaController.authorize();
          }),
    );
    // return FlutterMap(
    //   mapController: _mapController,
    //   options: MapOptions(
    //     maxZoom: 18,
    //     minZoom: 3,
    //   ),
    //   children: [
    //     TileLayer(
    //       urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    //       subdomains: const ['a', 'b', 'c'],
    //     ),
    //     if (latestPosition != null)
    //       MarkerLayer(
    //         markers: [
    //           Marker(
    //             point: latestPosition,
    //             width: 20,
    //             height: 20,
    //             // In 8.x, use 'child' instead of 'builder'
    //             child: const Icon(
    //               Icons.circle,
    //               color: Colors.red,
    //               size: 15,
    //             ),
    //           ),
    //         ],
    //       ),
    //     if (routePoints.isNotEmpty)
    //       PolylineLayer(
    //         polylines: [
    //           Polyline(
    //             points: routePoints,
    //             color: Colors.blue,
    //             strokeWidth: 4.0,
    //           ),
    //         ],
    //       ),
    //   ],
    // );
  }
}
