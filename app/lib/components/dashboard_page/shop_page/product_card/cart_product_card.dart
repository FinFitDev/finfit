import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class CartProductCard extends StatelessWidget {
  final ICartItem item;
  const CartProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Slidable(
        key: ValueKey(item.uuid),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) {
                shopController.removeCartItem(item.uuid!);
                triggerVibrate(FeedbackType.selection);
              },
              backgroundColor: colors.error,
              icon: Icons.delete,
              foregroundColor: colors.primary,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          height: 120,
          color: item.notEligible == true
              ? colors.errorContainer.withAlpha(20)
              : colors.primaryContainer,
          child: Row(
            children: [
              ImageBox(
                image: item.getImage(),
                height: 120 - 32,
                width: 120 - 32,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            )),
                        Text(item.variant?.createAttributesString() ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: colors.tertiaryContainer))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text:
                                '${item.product.finpointsPrice.toStringAsFixed(0)} finpoints',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: item.notEligible == true
                                    ? colors.tertiaryContainer
                                    : colors.secondary),
                            children: [
                              TextSpan(
                                  text: item.notEligible == true
                                      ? ' (Not eligible)'
                                      : '',
                                  style:
                                      TextStyle(color: colors.errorContainer)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${padPriceDecimals(item.getPrice())} PLN',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: item.notEligible == true
                                        ? colors.errorContainer
                                        : colors.tertiary)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RippleWrapper(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: colors.tertiaryContainer.withAlpha(20)),
                        child: Icon(
                          Icons.remove,
                          size: 12,
                          color: colors.primaryFixedDim,
                        ),
                      ),
                      onPressed: () {
                        shopController.decreaseProductQuantity(item.uuid!);
                      }),
                  Text(
                    item.quantity.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: colors.primaryFixedDim),
                  ),
                  RippleWrapper(
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: colors.secondary),
                          child: Icon(
                            Icons.add,
                            size: 12,
                            color: colors.primary,
                          )),
                      onPressed: () {
                        shopController.increaseProductQuantity(item.uuid!);
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
