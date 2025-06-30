import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/indicators/sliders/text_overflow_slider.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class TransactionInfoProducts extends StatelessWidget {
  final List<TransactionProduct> products;
  const TransactionInfoProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
            spacing: 16,
            children: products
                .map((product) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: RippleWrapper(
                              onPressed: () {
                                closeModal(context);

                                openModal(
                                    context,
                                    ProductInfoModal(
                                        productId: product.product.uuid));
                              },
                              child: Row(
                                children: [
                                  ImageComponent(
                                    size: 40,
                                    image: product.product
                                        .getImageByVariantId(product.variantId),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(product.product.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: colors.primaryFixedDim)),
                                        product.product.getVariantByVariantId(
                                                    product.variantId ?? '') !=
                                                null
                                            ? TextOverflowSlider(
                                                text: product.product
                                                    .getVariantByVariantId(
                                                        product.variantId ??
                                                            '')!
                                                    .createAttributesString(),
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: colors
                                                        .tertiaryContainer),
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<bool>(
                                      stream: dashboardController
                                          .balanceHiddenStream,
                                      builder: (context, snapshot) {
                                        bool isHidden = snapshot.data ?? false;
                                        return Text(
                                          '${isHidden ? '*****' : padPriceDecimals(product.calculatedPrice)} PLN',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      })
                                ],
                              )),
                        ),
                      ],
                    ))
                .toList()));
  }
}
