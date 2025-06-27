import 'dart:async';
import 'package:dio/dio.dart';
import 'package:excerbuys/components/shared/map/map_handler.dart';
import 'package:excerbuys/components/shop_page/checkout/map/delivery_point_search_component.dart';
import 'package:excerbuys/components/shop_page/checkout/map/location_selected_modal.dart';
import 'package:excerbuys/store/controllers/shop/checkout_controller/checkout_controller.dart';
import 'package:excerbuys/types/shop/delivery.dart';
import 'package:excerbuys/types/shop/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/shop/checkout/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  Timer? _debounce;
  final MapController _mapController = MapController();
  final List<IInpostOutOfTheBoxPoint> _points = [];
  IInpostOutOfTheBoxPoint? _selectedPoint;
  double? _visibleRadius = 80000;
  LatLng? currentCenter = WARSAW_COORDINATES;
  bool isLoading = true;
  bool isError = false;
  final CancelToken cancelToken = CancelToken();

  void fetchAllParcelPoints() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await httpHandler(
          url:
              'https://api-shipx-pl.easypack24.net/v1/points?per_page=40000&functions=parcel_collect',
          method: HTTP_METHOD.GET,
          cancelToken: cancelToken);

      final List<IInpostOutOfTheBoxPoint> points = [];
      for (final item in res['items']) {
        final addressDetails = item['address_details'];
        points.add(IInpostOutOfTheBoxPoint(
            id: item['name'],
            name: item['name'],
            description: item['location_description'],
            address: IAddressDetails(
                country: 'Polska',
                city: addressDetails['city'],
                street: addressDetails['street'],
                postCode: addressDetails['post_code'],
                houseNumber: addressDetails['building_number'],
                flatNumber: addressDetails['flat_number'],
                province: addressDetails['province']),
            coordinates: LatLng(
                item['location']['latitude'], item['location']['longitude']),
            image: item['image_url']));
      }
      if (!mounted) {
        return null;
      }
      setState(() {
        _points.clear();
        _points.addAll(points);
      });
    } catch (error) {
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllParcelPoints();
  }

  void _onMapMoved(MapCamera pos, bool hasGesture) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      final newCenter = pos.center;
      final double visibleMetersVertical = calculateVisibleMeters(
          newCenter.latitude, pos.zoom, MediaQuery.sizeOf(context).height);
      setState(() {
        currentCenter = newCenter;
        _visibleRadius = visibleMetersVertical;
      });
    });
  }

  List<IInpostOutOfTheBoxPoint>? get visiblePoints {
    if (currentCenter == null || _visibleRadius == null) return null;
    final visiblePoints = _points.where((point) {
      final distance = Distance();
      return distance.as(LengthUnit.Meter, currentCenter!, point.coordinates) <=
          _visibleRadius!;
    }).toList();

    return visiblePoints.isNotEmpty ? visiblePoints : null;
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
        cancelToken.cancel();
        closeModal(context);
      },
      onClickBack: () {
        cancelToken.cancel();

        widget.prevPage();
      },
      padding: EdgeInsets.all(0),
      child: Stack(
        children: [
          MapHandler(
            onLocalize: (pos) {
              setState(() {
                myLocation = pos;
              });
            },
            mapController: _mapController,
            onMapMoved: _onMapMoved,
            markers: (visiblePoints ?? [])
                .map(
                  (el) => Marker(
                    height: 50,
                    width: 50,
                    point: el.coordinates,
                    child: RippleWrapper(
                      onPressed: () {
                        setState(() {
                          _selectedPoint = el;
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/svg/inpost_marker.svg',
                        width: 50,
                      ),
                    ),
                  ),
                )
                .toList(),
            aggregateMarkerBuilder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 59, 66, 71)),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 230, 205, 40),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
          StreamBuilder<({String? orderId, IDeliveryMethod? deliveryMethod})>(
              stream: checkoutController.combinedProcessingStream,
              builder: (context, snapshot) {
                return LocationSelectedModal(
                  onClickCancel: () {
                    setState(() {
                      _selectedPoint = null;
                    });
                  },
                  onClickSelect: () {
                    if (_selectedPoint != null &&
                        snapshot.data?.deliveryMethod != null &&
                        snapshot.data?.orderId != null) {
                      final IDeliveryDetails deliveryDetails = IDeliveryDetails(
                        deliveryMethod: snapshot.data!.deliveryMethod!,
                        deliveryPointId: _selectedPoint?.id,
                        deliveryPointDescription: _selectedPoint?.description,
                        deliveryPointName: _selectedPoint?.name,
                        addressDetails: _selectedPoint?.address,
                      );

                      checkoutController.changeOrderDeliveryDetails(
                          snapshot.data!.orderId!, deliveryDetails);

                      widget.nextPage();
                    }
                  },
                  selectedPoint: _selectedPoint,
                );
              }),
          DeliveryPointSearchComponent<dynamic>(
            centerLocation: () {
              _mapController.move(myLocation ?? WARSAW_COORDINATES, 10);
            },
            points: _points,
            myLocation: myLocation ?? WARSAW_COORDINATES,
            onPointSelected: (p) {
              setState(() {
                _selectedPoint = p;
                _mapController.move(p.coordinates, 15);
              });
            },
          ),
          isLoading || isError
              ? Positioned(
                  child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      color: colors.primary,
                      child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: colors.secondary,
                                )
                              : Text(
                                  'Błąd podczas ładowania punktów paczkomatów',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colors.tertiaryContainer,
                                    fontSize: 16,
                                  ),
                                )),
                    )),
                  ],
                ))
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
