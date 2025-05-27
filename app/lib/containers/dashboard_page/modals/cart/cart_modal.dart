import 'package:excerbuys/components/dashboard_page/shop_page/product_card/cart_product_card.dart';
import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';

class CartModal extends StatelessWidget {
  const CartModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return ModalContentWrapper(
      child: StreamBuilder<List<ICartItem>>(
          stream: shopController.cartItemsStream,
          builder: (context, snapshot) {
            final int totalQuantity =
                snapshot.data != null ? countQuantity(snapshot.data!) : 0;
            return Column(
              children: [
                ModalHeader(
                  title: 'Cart',
                  subtitle: '$totalQuantity items selected',
                  onClose: () {
                    closeModal(context);
                  },
                ),
                Expanded(
                  child: totalQuantity == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              'No products in cart yet',
                              style: texts.headlineMedium
                                  ?.copyWith(color: colors.tertiaryContainer),
                            ))
                          ],
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return Container(
                                margin: EdgeInsets.only(
                                    bottom: index < snapshot.data!.length - 1
                                        ? 8
                                        : 0),
                                child: CartProductCard(
                                  item: item,
                                ));
                          },
                          itemCount: snapshot.data!.length),
                ),
                Container(height: 0.2, color: colors.tertiaryContainer),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Finpoints price',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: colors.tertiaryContainer)),
                          StreamBuilder<int>(
                              stream:
                                  shopController.totalCartFinpointsCostStream,
                              builder: (context, snapshot) {
                                return Text(
                                    snapshot.data != null
                                        ? ' ${snapshot.data!.toStringAsFixed(0)} finpoints'
                                        : ' 0 finpoints',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: colors.primaryFixedDim));
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total price',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: colors.tertiaryContainer)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StreamBuilder<double>(
                                  stream: shopController
                                      .totalCartPriceWithoutDeliveryCostStream,
                                  builder: (context, snapshot) {
                                    return Text(
                                        ' ${padPriceDecimals(snapshot.data ?? 0)} PLN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: colors.secondary));
                                  }),
                              Text(
                                '(Doesn’t include shipping costs)',
                                style: TextStyle(
                                    fontSize: 10, color: colors.secondary),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                MainButton(
                    label: 'Checkout',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    isDisabled: totalQuantity == 0,
                    onPressed: () {})
              ],
            );
          }),
    );
  }
}
