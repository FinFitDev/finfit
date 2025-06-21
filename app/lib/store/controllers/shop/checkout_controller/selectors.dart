part of 'checkout_controller.dart';

extension CheckoutControllerSelectors on CheckoutController {
  Stream<int> get totalCartFinpointsCostStream =>
      cartItemsStream.map(countTotalCartFinpointsCost);

  Stream<double> get totalCartPriceWithoutDeliveryCostStream =>
      cartItemsStream.map(countTotalCartPrice);

  Stream<double> get totalCartDiscountValueSaved =>
      cartItemsStream.map(getTotalDiscountSavings);

  Stream<double?> get userBalanceMinusCartCost => Rx.combineLatest2(
      userController.userBalanceStream,
      totalCartFinpointsCostStream,
      getUserBalanceMinusCartCost);
}
