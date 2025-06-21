import 'dart:math';

import 'package:excerbuys/types/shop/checkout.dart';
import 'package:excerbuys/types/shop/delivery.dart';
import 'package:excerbuys/types/shop/shop.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:latlong2/latlong.dart';

Map<String, List<ICartItem>> groupProductsByOwner(List<ICartItem> cartItems) {
  final Map<String, List<ICartItem>> groupedItems = {};

  for (final item in cartItems) {
    final ownerId = item.product.owner.uuid;
    if (groupedItems.containsKey(ownerId)) {
      groupedItems[ownerId]!.add(item);
    } else {
      groupedItems[ownerId] = [item];
    }
  }

  return groupedItems;
}

List<IDeliveryGroup> createDeliveryGroups(List<ICartItem> cartItems) {
  final groupedItems = groupProductsByOwner(cartItems);
  return groupedItems.entries.map((entry) {
    final owner = entry.value.first.product.owner;
    final List<IDeliveryMethod>? deliveryMethods = owner.deliveryMethods
            ?.map((method) {
              return method.copyWith(
                  unavailableFor: entry.value
                      .where((item) =>
                          item.product.unavaialbleDeliveryMethods
                              ?.contains(method.uuid) ??
                          false)
                      .map((item) => item.product.name)
                      .toList());
            })
            .toList()
            .cast<IDeliveryMethod>() ??
        [];

    return IDeliveryGroup(
      owner: owner,
      items: entry.value,
      uuid: entry.key,
      deliveryMethods: deliveryMethods,
    );
  }).toList();
}

double calculateVisibleMeters(
    double latitude, double zoom, double screenWidth) {
  final metersPerPixel = 156543.03392 * cos(latitude * pi / 180) / pow(2, zoom);
  return metersPerPixel * screenWidth;
}

bool isSignificantChange(LatLng oldCenter, LatLng newCenter, double radius) {
  final Distance distance = Distance();
  return distance.as(LengthUnit.Meter, oldCenter, newCenter) > radius;
}

String calculateDistance(
  LatLng point1,
  LatLng point2, {
  LengthUnit unit = LengthUnit.Meter,
}) {
  final Distance distance = Distance();
  final double dist = distance.as(LengthUnit.Meter, point1, point2);

  if (dist >= 1000000) {
    return '>999 km';
  } else if (dist >= 1000) {
    return '${(dist / 1000).toStringAsFixed(2)} km';
  } else {
    return '${dist.toStringAsFixed(0)} m';
  }
}

Future<String?> getCityForPostCode(String postCode) async {
  try {
    final response = await httpHandler(
        url: 'http://api.zippopotam.us/pl/$postCode', method: HTTP_METHOD.GET);

    if (response == null ||
        response == null ||
        response['places'] == null ||
        response['places'].isEmpty) {
      return null;
    }

    return response['places'][0]['place name'] as String?;
  } catch (err) {
    return null;
  }
}
