import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
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
    if (foundTransaction?.product != null) {
      productsController.addProducts(
          {foundTransaction!.product!.uuid: foundTransaction.product!});
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
                                    ? ImageComponent(
                                        size: 80,
                                        image: _transaction?.product?.image,
                                      )
                                    : ProfileImageGenerator(
                                        size: 80,
                                        seed: _transaction?.secondUser?.image,
                                      ),
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
                          height: 32,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              StreamBuilder<bool>(
                                  stream:
                                      dashboardController.balanceHiddenStream,
                                  builder: (context, snapshot) {
                                    final bool isHidden =
                                        snapshot.data ?? false;
                                    return ListComponent(
                                      data: {
                                        'Status': 'Confirmed',
                                        'Timestamp':
                                            '${_transaction!.createdAt.hour}:${_transaction!.createdAt.minute.toString().padLeft(2, '0')}',
                                        if (_transaction?.secondUser != null)
                                          'Interacted with': Row(
                                            children: [
                                              PositionWithBackground(
                                                name: _transaction?.secondUser
                                                        ?.username ??
                                                    'Unknown',
                                                image: _transaction
                                                    ?.secondUser?.image,
                                                textStyle: TextStyle(
                                                  color:
                                                      colors.tertiaryContainer,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (_transaction?.product != null)
                                          'Product': Row(
                                            children: [
                                              RippleWrapper(
                                                onPressed: () {
                                                  closeModal(context);

                                                  openModal(
                                                      context,
                                                      ProductInfoModal(
                                                          productId:
                                                              _transaction!
                                                                  .product!
                                                                  .uuid));
                                                },
                                                child: PositionWithBackground(
                                                  name: _transaction
                                                          ?.product?.name ??
                                                      'Unknown',
                                                  image: _transaction
                                                      ?.product?.image,
                                                  textStyle: TextStyle(
                                                    color: colors
                                                        .tertiaryContainer,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      },
                                      summary:
                                          '${isHidden ? '*****' : '${_transactionType == TRANSACTION_TYPE.RECEIVE ? '+' : '-'}${formatNumber(_transaction?.amountFinpoints?.round() ?? _transaction?.product?.finpointsPrice.round() ?? 0)}'} finpoints',
                                      summaryColor: color,
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Text(
                          'Transaction ID',
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
                            label: 'Close',
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
