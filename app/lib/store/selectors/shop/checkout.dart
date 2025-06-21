import 'dart:math';

import 'package:excerbuys/types/shop/checkout.dart';

int countTotalCartFinpointsCost(List<ICartItem> cartItems) {
  return cartItems.fold(
      0,
      (count, item) =>
          count +
          (item.notEligible == true
              ? 0
              : (item.product.finpointsPrice.round() * item.quantity)));
}

double countTotalCartPrice(List<ICartItem> cartItems) {
  return cartItems.fold(0, (count, item) {
    return count + (item.getPrice() * item.quantity);
  });
}

double? getUserBalanceMinusCartCost(double? userBalance, int cartCost) {
  return max(0, (userBalance ?? 0) - cartCost);
}

double getTotalDiscountSavings(List<ICartItem> cartItems) {
  return cartItems.fold(
      0,
      (count, item) =>
          count +
          ((item.getPrice(isEligible: false) - item.getPrice()) *
              item.quantity));
}
