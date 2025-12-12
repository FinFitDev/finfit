import 'package:excerbuys/components/dashboard_page/shop_page/cart/cart_modal_summary.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_card/cart_product_card.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class CartModal extends StatelessWidget {
  const CartModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return StreamBuilder<List<ICartItem>>(
        stream: shopController.cartItemsStream,
        builder: (context, snapshot) {
          final int totalQuantity =
              snapshot.data != null ? countQuantity(snapshot.data!) : 0;
          return ModalContentWrapper(
              title: l10n.textCartTitle,
              onClose: () {
                closeModal(context);
              },
              child: Column(
                children: [
                  Expanded(
                    child: totalQuantity == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                l10n.textCartEmpty,
                                style: texts.headlineMedium
                                    ?.copyWith(color: colors.tertiaryContainer),
                              ))
                            ],
                          )
                        : Stack(
                            children: [
                              ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  itemBuilder: (context, index) {
                                    final item = snapshot.data![index];
                                    return Container(
                                        margin: EdgeInsets.only(
                                            bottom: index <
                                                    snapshot.data!.length - 1
                                                ? 8
                                                : 0),
                                        child: CartProductCard(
                                          item: item,
                                        ));
                                  },
                                  itemCount: snapshot.data!.length),
                              // Positioned(
                              //     bottom: 16,
                              //     left: 0,
                              //     right: 0,
                              //     child: Container(
                              //       padding: EdgeInsets.all(10),
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10),
                              //         color: colors.tertiary,
                              //       ),
                              //       child: Column(
                              //         spacing: 4,
                              //         children: [
                              //           Text(
                              //             'Price optimized',
                              //             style: TextStyle(
                              //                 color: colors.primary,
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 12),
                              //           ),
                              //           Text(
                              //             'The price has been optimized taking into account the max discount available on each products set not yet qualified for the discount',
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color:
                              //                     colors.primary.withAlpha(190),
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 8),
                              //           ),
                              //         ],
                              //       ),
                              //     ))
                            ],
                          ),
                  ),
                  CartModalSummary(),
                  Text(l10n.textCartPriceNote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: colors.tertiaryContainer,
                          fontSize: 12)),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 2,
                        child: MainButton(
                            label: l10n.actionCheckout,
                            backgroundColor: colors.secondary,
                            textColor: colors.primary,
                            isDisabled: totalQuantity == 0,
                            onPressed: () {}),
                      ),
                    ],
                  )
                ],
              ));
        });
  }
}
