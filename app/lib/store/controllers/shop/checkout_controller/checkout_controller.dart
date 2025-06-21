import 'dart:convert';
import 'dart:math';

import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/shop/checkout.dart';
import 'package:excerbuys/types/shop/checkout.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';
import 'package:rxdart/rxdart.dart';

part 'mutations.dart';
part 'selectors.dart';
part 'effects.dart';

class CheckoutController {
  final BehaviorSubject<List<ICartItem>> _cartItems =
      BehaviorSubject.seeded([]);
  Stream<List<ICartItem>> get cartItemsStream => _cartItems.stream;
  List<ICartItem> get cartItems => _cartItems.value;

  final BehaviorSubject<IUserOrderData?> _userOrderData =
      BehaviorSubject.seeded(null);
  Stream<IUserOrderData?> get userOrderDataStream => _userOrderData.stream;
  IUserOrderData? get userOrderData => _userOrderData.value;
}

CheckoutController checkoutController = CheckoutController();
