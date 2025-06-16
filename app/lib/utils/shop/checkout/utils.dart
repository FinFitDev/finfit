import 'dart:math';

import 'package:excerbuys/types/delivery.dart';
import 'package:excerbuys/types/shop.dart';
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
