import 'dart:math';

import 'package:excerbuys/components/dashboard_page/history_page/transaction_info_modal/transaction_info_products.dart';
import 'package:excerbuys/components/dashboard_page/history_page/transaction_info_modal/transaction_info_users.dart';
import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/indicators/images_row.dart';
import 'package:excerbuys/components/shared/indicators/labels/empty_data_modal.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller/products_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/transaction/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class TransactionInfoModal extends StatefulWidget {
  final String transactionId;
  const TransactionInfoModal({super.key, required this.transactionId});

  @override
  State<TransactionInfoModal> createState() => _TransactionInfoModalState();
}

class _TransactionInfoModalState extends State<TransactionInfoModal> {
  bool _error = false;
  ITransactionEntry? _transaction;
  TRANSACTION_TYPE? _transactionType;
  int _daysAgo = 0;

  void getTransactionMetadata() {
    final foundTransaction =
        transactionsController.allTransactions.content[widget.transactionId];

    // add product that are referenced in a transaction
    if (foundTransaction?.products != null) {
      productsController.addProducts({
        for (final entry in foundTransaction!.products!)
          entry.product.uuid: entry.product
      });
    }

    if (foundTransaction == null) {
      setState(() {
        _error = true;
      });
      return;
    }
    final now = DateTime.now();
    setState(() {
      _daysAgo = DateTime(now.year, now.month, now.day)
          .difference(DateTime(foundTransaction.createdAt.year,
              foundTransaction.createdAt.month, foundTransaction.createdAt.day))
          .inDays;
      _transaction = foundTransaction;
      _transactionType = transactionTypeStringToEnum(_transaction?.type ?? '');
    });
  }

  @override
  void initState() {
    super.initState();

    getTransactionMetadata();
  }

  @override
  void didUpdateWidget(covariant TransactionInfoModal oldWidget) {
    if (widget.transactionId != oldWidget.transactionId) {
      getTransactionMetadata();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final color = _transactionType == TRANSACTION_TYPE.PURCHASE ||
            _transactionType == TRANSACTION_TYPE.SEND
        ? colors.error
        : colors.secondary;

    final isUsers = _transaction?.secondUsers != null &&
        _transaction!.secondUsers!.isNotEmpty;

    final isProducts =
        _transaction?.products != null && _transaction!.products!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjust with keyboard
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MODAL_BORDER_RADIUS),
              topRight: Radius.circular(MODAL_BORDER_RADIUS)),
          child: Container(
              height: MediaQuery.sizeOf(context).height * 0.9,
              color: colors.primary,
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 2 * HORIZOTAL_PADDING,
                  left: HORIZOTAL_PADDING,
                  right: HORIZOTAL_PADDING,
                  bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
              child: _error
                  ? EmptyDataModal(
                      message: "Couldn't find transaction data",
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                _transactionType == TRANSACTION_TYPE.PURCHASE
                                    ? ImagesRow(
                                        images: isProducts
                                            ? _transaction!.products!
                                                .map((product) =>
                                                    product.product
                                                        .getImageByVariantId(
                                                            product
                                                                .variantId) ??
                                                    '')
                                                .toList()
                                            : [],
                                        size: 80)
                                    : ImagesRow(
                                        images: isUsers
                                            ? _transaction!.secondUsers!
                                                .map((user) => user.image ?? '')
                                                .toList()
                                            : [],
                                        isProfile: true,
                                        size: 80),
                                _transactionType != TRANSACTION_TYPE.PURCHASE
                                    ? Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: IconContainer(
                                          icon: _transactionType ==
                                                  TRANSACTION_TYPE.RECEIVE
                                              ? 'assets/svg/receiveArrow.svg'
                                              : 'assets/svg/sendArrow.svg',
                                          size: 30,
                                          ratio: 0.7,
                                          backgroundColor: color,
                                        ))
                                    : SizedBox.shrink()
                              ],
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalizeFirst(_transaction?.type),
                                  textAlign: TextAlign.start,
                                  style: texts.headlineLarge
                                      ?.copyWith(color: color),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getDayName(_daysAgo)}, ${getDayNumber(_daysAgo)} ${getDayMonth(_daysAgo)} ${getDayYear(_daysAgo)}',
                                  textAlign: TextAlign.left,
                                  style: texts.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: colors.tertiaryContainer),
                                ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                StreamBuilder<bool>(
                                    stream:
                                        dashboardController.balanceHiddenStream,
                                    builder: (context, snapshot) {
                                      final bool isHidden =
                                          snapshot.data ?? false;
                                      return Column(
                                        children: [
                                          ListComponent(
                                            data: {
                                              'Status':
                                                  Row(spacing: 6, children: [
                                                Text(
                                                  'Potwierdzono',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              105,
                                                              190,
                                                              149),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                IconContainer(
                                                  icon: 'assets/svg/tick.svg',
                                                  size: 14,
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 105, 190, 149),
                                                  iconColor: colors.primary,
                                                )
                                              ]),
                                              'Godzina':
                                                  '${_transaction!.createdAt.hour}:${_transaction!.createdAt.minute.toString().padLeft(2, '0')}',
                                              if (isUsers) 'Interakcja z': '',
                                              if (isProducts) 'Produkty': ''
                                            },
                                          ),
                                          isUsers
                                              ? TransactionInfoUsers(
                                                  users: _transaction!
                                                      .secondUsers!,
                                                  totalFinpoints: _transaction!
                                                          .amountFinpoints ??
                                                      0)
                                              : isProducts
                                                  ? TransactionInfoProducts(
                                                      products: _transaction!
                                                          .products!)
                                                  : SizedBox.shrink(),
                                          ListComponent(
                                            data: {},
                                            summary:
                                                '${isHidden ? '*****' : '${_transactionType == TRANSACTION_TYPE.RECEIVE ? '+' : '-'}${formatNumber(_transaction?.amountFinpoints?.round() ?? _transaction?.products?[0].product.finpointsPrice.round() ?? 0)}'} finpoints',
                                            summaryColor: color,
                                          )
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'ID transakcji',
                          style: TextStyle(
                            color: colors.tertiaryContainer,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CopyText(textToCopy: _transaction?.uuid ?? ''),
                        SizedBox(
                          height: 24,
                        ),
                        MainButton(
                            label: 'Zamknij',
                            backgroundColor:
                                colors.tertiaryContainer.withAlpha(80),
                            textColor: colors.primaryFixedDim,
                            onPressed: () {
                              closeModal(context);
                            })
                      ],
                    ))),
    );
  }
}
