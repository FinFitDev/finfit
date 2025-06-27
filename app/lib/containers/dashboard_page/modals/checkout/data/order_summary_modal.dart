import 'dart:convert';

import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/checkout_controller/checkout_controller.dart';
import 'package:excerbuys/types/shop/checkout.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';

class OrderSummaryModal extends StatefulWidget {
  final void Function() prevPage;
  final void Function() nextPage;
  const OrderSummaryModal(
      {super.key, required this.prevPage, required this.nextPage});

  @override
  State<OrderSummaryModal> createState() => _OrderSummaryModalState();
}

class _OrderSummaryModalState extends State<OrderSummaryModal> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<List<IOrder>>(
        stream: checkoutController.filteredOrdersStream,
        builder: (context, snapshot) {
          return ModalContentWrapper(
            title: 'Podsumowanie',
            subtitle: 'Sprawdź swoje zamówienie',
            onClose: () {
              closeModal(context);
            },
            padding: EdgeInsets.only(
                left: HORIZOTAL_PADDING,
                right: HORIZOTAL_PADDING,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    layoutController.bottomPadding +
                    16),
            onClickBack: widget.prevPage,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: (snapshot.data ?? [])
                              .map((el) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          el.uuid,
                                          style: TextStyle(
                                              color: colors.onPrimaryContainer,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Ilość: ${jsonEncode(el.cartItemsIds)}',
                                          style: TextStyle(
                                              color: colors.onPrimaryContainer
                                                  .withOpacity(0.7),
                                              fontSize: 14),
                                        ),
                                        Text(
                                          'Dostawa: ${jsonEncode(el.deliveryDetails)}',
                                          style: TextStyle(
                                              color:
                                                  colors.error.withOpacity(0.7),
                                              fontSize: 14),
                                        ),
                                        Text(
                                          'Dane: ${jsonEncode(el.userData)}',
                                          style: TextStyle(
                                              color: colors.secondary
                                                  .withOpacity(0.7),
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList()),
                    ),
                  ),
                ),
                MainButton(
                    label: 'Potwierdź',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    onPressed: () {}),
              ],
            ),
          );
        });
  }
}
