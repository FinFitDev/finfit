import 'dart:convert';
import 'dart:math';

import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/shop/checkout.dart';
import 'package:excerbuys/types/shop/checkout.dart';
import 'package:excerbuys/types/shop/delivery.dart';
import 'package:excerbuys/types/shop/shop.dart';
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

  final BehaviorSubject<List<IOrder>> _orders = BehaviorSubject.seeded([]);
  Stream<List<IOrder>> get ordersStream => _orders.stream;
  List<IOrder> get orders => _orders.value;

  final BehaviorSubject<String?> _currentlyProcessedOrderId =
      BehaviorSubject.seeded(null);
  Stream<String?> get currentlyProcessedOrderIdStream =>
      _currentlyProcessedOrderId.stream;
  String? get currentlyProcessedOrderId => _currentlyProcessedOrderId.value;

  final BehaviorSubject<IDeliveryMethod?> _currentlyProcessedDeliveryMethod =
      BehaviorSubject.seeded(null);
  Stream<IDeliveryMethod?> get currentlyProcessedDeliveryMethodStream =>
      _currentlyProcessedDeliveryMethod.stream;
  IDeliveryMethod? get currentlyProcessedDeliveryMethod =>
      _currentlyProcessedDeliveryMethod.value;
}

CheckoutController checkoutController = CheckoutController();
