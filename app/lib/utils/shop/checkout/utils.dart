import 'package:excerbuys/types/shop.dart';

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

    return IDeliveryGroup(
      owner: owner,
      items: entry.value,
      uuid: entry.key,
      // TODO: handle delivery methods unavailability for products
      deliveryMethods: owner.deliveryMethods ?? [],
    );
  }).toList();
}
