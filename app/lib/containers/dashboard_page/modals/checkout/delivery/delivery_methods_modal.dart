import 'package:excerbuys/components/dashboard_page/shop_page/checkout/delivery/delivery_group.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/shop/checkout/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';

class DeliveryMethodsModal extends StatefulWidget {
  final void Function() previousPage;
  final void Function() nextPage;
  const DeliveryMethodsModal(
      {super.key, required this.previousPage, required this.nextPage});

  @override
  State<DeliveryMethodsModal> createState() => _DeliveryMethodsModalState();
}

class _DeliveryMethodsModalState extends State<DeliveryMethodsModal> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return StreamBuilder<List<ICartItem>>(
        stream: shopController.cartItemsStream,
        builder: (context, snapshot) {
          final List<IDeliveryGroup> deliveryGroups =
              snapshot.data != null ? createDeliveryGroups(snapshot.data!) : [];

          return ModalContentWrapper(
            title: 'Delivery options',
            subtitle: 'Select your delivery methods',
            onClose: () {
              closeModal(context);
            },
            onClickBack: widget.previousPage,
            child: Column(
              children: [
                Expanded(
                    child: deliveryGroups.isEmpty
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
                            itemCount: deliveryGroups.length,
                            padding: EdgeInsets.only(top: 16),
                            itemBuilder: (context, index) {
                              final group = deliveryGroups[index];
                              return DeliveryGroup(
                                deliveryGroup: group,
                              );
                            })),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: StreamBuilder<double>(
                          stream: shopController
                              .totalCartPriceWithoutDeliveryCostStream,
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 4,
                              children: [
                                Text(
                                  'Cena',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: colors.tertiaryContainer),
                                ),
                                Text(
                                  ' 24 PLN',
                                  textAlign: TextAlign.center,
                                  style: texts.headlineMedium,
                                )
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: MainButton(
                          label: 'Confirm',
                          backgroundColor: colors.secondary,
                          textColor: colors.primary,
                          onPressed: () {
                            widget.nextPage();
                          }),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
