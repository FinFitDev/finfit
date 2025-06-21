import 'dart:math';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/types/shop/delivery.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/shop/checkout/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DeliveryPointSearchComponent<T> extends StatefulWidget {
  final void Function()? centerLocation;
  final List<T> points;
  final LatLng myLocation;
  final void Function(T) onPointSelected;

  const DeliveryPointSearchComponent(
      {super.key,
      this.centerLocation,
      required this.points,
      required this.myLocation,
      required this.onPointSelected});

  @override
  State<DeliveryPointSearchComponent> createState() =>
      _DeliveryPointSearchComponentState();
}

class _DeliveryPointSearchComponentState<T>
    extends State<DeliveryPointSearchComponent<T>> {
  String _searchValue = '';
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() {
      _isOpen = true;
    });
  }

  List<T> get pointsForSearch {
    final searchValue = _searchValue.toLowerCase();
    final Distance distance = Distance();

    final List<T> filtered = widget.points
        .where((dynamic point) {
          final pointName = point.name.toLowerCase();
          final pointDescription = point.description.toLowerCase();
          final address = (point.address as IAddressDetails)
              .toAddressString()
              .toLowerCase();

          return pointName.contains(searchValue) ||
              pointDescription.contains(searchValue) ||
              address.contains(searchValue);
        })
        .take(15)
        .toList();

    // Sort by distance from `widget.myLocation`
    filtered.sort((dynamic a, dynamic b) {
      final double distA =
          distance.as(LengthUnit.Meter, a.coordinates, widget.myLocation);
      final double distB =
          distance.as(LengthUnit.Meter, b.coordinates, widget.myLocation);
      return distA.compareTo(distB);
    });

    return filtered.toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Positioned(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: _isOpen ? colors.primary : null,
              padding: EdgeInsets.only(
                  left: HORIZOTAL_PADDING,
                  right: HORIZOTAL_PADDING,
                  top: HORIZOTAL_PADDING),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: InputWithIcon(
                          placeholder: 'Wyszukaj paczkomat',
                          onChange: (val) {
                            _debouncer.run(() {
                              setState(() {
                                _searchValue = val;
                              });
                            });
                          },
                          rightIcon:
                              _isOpen ? null : 'assets/svg/locate_me.svg',
                          borderRadius: 10,
                          verticalPadding: 12,
                          onTap: _openSearch,
                          onPressRightIcon: widget.centerLocation,
                        ),
                      ),
                      _isOpen
                          ? RippleWrapper(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Text(
                                    'Anuluj',
                                    style: TextStyle(
                                        color: colors.tertiaryContainer),
                                  )),
                              onPressed: () {
                                setState(() {
                                  _isOpen = false;
                                  _searchValue = '';
                                });
                                FocusScope.of(context).unfocus();
                              })
                          : SizedBox.shrink()
                    ],
                  ),
                  _isOpen ? SizedBox(height: 16) : SizedBox.shrink(),
                  _isOpen
                      ? Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              itemBuilder: (context, index) {
                                final dynamic point = pointsForSearch[index];
                                if (point == null) {
                                  return SizedBox.shrink();
                                }

                                return RippleWrapper(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    widget.onPointSelected(point);
                                    setState(() {
                                      _isOpen = false;
                                      _searchValue = '';
                                    });
                                  },
                                  child: Container(
                                    height: 56,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      spacing: 16,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                '${point.name} ${point.description}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                point.address.toAddressString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: colors
                                                        .tertiaryContainer),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              calculateDistance(
                                                  point.coordinates,
                                                  widget.myLocation),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      colors.primaryFixedDim),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  _isOpen ? min(pointsForSearch.length, 15) : 0,
                              shrinkWrap: true),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
