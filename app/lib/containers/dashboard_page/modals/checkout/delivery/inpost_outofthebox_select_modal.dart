import 'dart:async';

import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/store/controllers/app_controller/app_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/shop/checkout/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class InpostOutoftheboxSelectModal extends StatefulWidget {
  final void Function() prevPage;
  final void Function() nextPage;

  const InpostOutoftheboxSelectModal(
      {super.key, required this.prevPage, required this.nextPage});

  @override
  State<InpostOutoftheboxSelectModal> createState() =>
      _InpostOutoftheboxSelectModalState();
}

class _InpostOutoftheboxSelectModalState
    extends State<InpostOutoftheboxSelectModal> {
  LatLng? myLocation;
  StreamSubscription<Position?>? _locationSubscription;
  Timer? _debounce;
  LatLng _lastFetchedCenter = LatLng(52.2297, 21.0122); // Warsaw coordinates
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    appController.getCurrentLocation();
    _locationSubscription =
        appController.currentLocationStream.listen((location) {
      if (location != null) {
        final newLatLng = LatLng(location.latitude, location.longitude);
        setState(() {
          myLocation = newLatLng;
        });
        // TODO: Uncomment the line below to move the map to the user's location
        // _mapController.move(newLatLng, _mapController.camera.zoom);
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  void fetchAllParcelPoints() {}

  void _onMapMoved(MapCamera pos, bool hasGesture) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () {
      final newCenter = pos.center;
      final double visibleMeters = calculateVisibleMeters(
          newCenter.latitude, pos.zoom, MediaQuery.sizeOf(context).width);
      if (isSignificantChange(_lastFetchedCenter, newCenter, visibleMeters)) {
        _lastFetchedCenter = newCenter;
        print('now');
        // fetchLockers(newCenter.latitude, newCenter.longitude);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ModalContentWrapper(
      title: 'Paczkomaty InPost',
      subtitle: 'Wybierz paczkomat',
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS51q8ZkBRKAAZKDJ9rWC5gax4v5etya2c3g&s',
      onClose: () {
        closeModal(context);
      },
      onClickBack: () {
        widget.prevPage();
      },
      padding: EdgeInsets.all(0),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                // Warsaw coordinates
                onPositionChanged: _onMapMoved,
                initialCenter: LatLng(52.2297, 21.0122),
                initialZoom: 10),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              // MarkerLayer(
              //   markers: [
              //     Marker(
              //       height: 70,
              //       width: 70,
              //       point: LatLng(52.1297, 21),
              //       child: RippleWrapper(
              //         onPressed: () {
              //           print('pressed');
              //         },
              //         child: SvgPicture.asset(
              //           'assets/svg/inpost_marker.svg',
              //           width: 70,
              //         ),
              //       ),
              //     ),
              //     Marker(
              //       height: 70,
              //       width: 70,
              //       point: LatLng(52.127, 20.99),
              //       child: RippleWrapper(
              //         onPressed: () {
              //           print('pressed');
              //         },
              //         child: SvgPicture.asset(
              //           'assets/svg/inpost_marker.svg',
              //           width: 70,
              //         ),
              //       ),
              //     ),
              //     Marker(
              //       height: 70,
              //       width: 70,
              //       point: LatLng(52.1197, 21.012),
              //       child: RippleWrapper(
              //         onPressed: () {
              //           print('pressed');
              //         },
              //         child: SvgPicture.asset(
              //           'assets/svg/inpost_marker.svg',
              //           width: 70,
              //         ),
              //       ),
              //     ),
              //   ], // lista Markerów z fetchMarkersNearLocation
              // ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: InputWithIcon(
              placeholder: 'Wyszukaj paczkomat',
              onChange: (val) {},
              rightIcon: 'assets/svg/locate_me.svg',
              borderRadius: 10,
              verticalPadding: 12,
              onPressRightIcon: () {
                _mapController.move(myLocation ?? LatLng(52.2297, 21.0122),
                    _mapController.camera.zoom);
              },
            ),
          ),
          Positioned(
              bottom: layoutController.bottomPadding + 16,
              right: 16,
              child: Column(
                spacing: 8,
                children: [
                  RippleWrapper(
                    onPressed: () {
                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom + 1.0,
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: colors.primaryContainer),
                      child: Icon(
                        Icons.add,
                        size: 25,
                        color: colors.primaryFixedDim,
                      ),
                    ),
                  ),
                  RippleWrapper(
                    onPressed: () {
                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom - 1.0,
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: colors.primaryContainer),
                      child: Icon(
                        Icons.remove,
                        size: 25,
                        color: colors.primaryFixedDim,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
