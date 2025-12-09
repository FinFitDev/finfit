import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/positions/position_with_title.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/containers/dashboard_page/modals/all_claims_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/offer_info_modal.dart';
import 'package:excerbuys/store/controllers/shop/claims_controller/claims_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/transaction/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TransactionInfoModal extends StatefulWidget {
  final String transactionId;
  const TransactionInfoModal({super.key, required this.transactionId});

  @override
  State<TransactionInfoModal> createState() => _TransactionInfoModalState();
}

class _TransactionInfoModalState extends State<TransactionInfoModal> {
  ITransactionEntry? _transaction;
  TRANSACTION_TYPE? _transactionType;
  int _daysAgo = 0;

  void getTransactionMetadata() {
    final foundTransaction =
        transactionsController.allTransactions.content[widget.transactionId];

    // add product that are referenced in a transaction
    if (foundTransaction?.offer != null) {}

    if (foundTransaction == null) {
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

    final color = getTransactionTypeColor(
        _transactionType ?? TRANSACTION_TYPE.UNKNOWN, colors);

    return ModalContentWrapper(
      title: getTransactionTitle(_transactionType ?? TRANSACTION_TYPE.UNKNOWN),
      onClose: () {
        closeModal(context);
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          IconContainer(
                            icon: getTransactionTypeIcon(
                                _transactionType ?? TRANSACTION_TYPE.UNKNOWN),
                            size: 60,
                            backgroundColor: color,
                            iconColor: colors.primary,
                            borderRadius: 200,
                          ),
                          Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_transactionType == TRANSACTION_TYPE.RECEIVE ? "+" : '-'}${(_transaction?.amountPoints ?? 0).toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: color),
                              ),
                              Text(
                                'points',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: color.withAlpha(150)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    PositionWithTitle(
                      title: 'Transaction timestamp',
                      value: _transaction != null
                          ? parseDate(_transaction!.createdAt)
                          : "",
                      icon: 'assets/svg/clock.svg',
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: colors.primaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            spreadRadius: -5,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        spacing: 8,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              SvgPicture.asset(
                                _transactionType == TRANSACTION_TYPE.REDEEM
                                    ? 'assets/svg/gift.svg'
                                    : 'assets/svg/people.svg',
                                colorFilter: ColorFilter.mode(
                                    colors.primaryFixedDim, BlendMode.srcIn),
                                height: 20,
                              ),
                              Text(
                                getTransactionTypeText(_transactionType ??
                                    TRANSACTION_TYPE.UNKNOWN),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.primaryFixedDim,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ...(_transaction?.secondUsers ?? [])
                              .map((user) => Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: colors.tertiaryContainer
                                            .withAlpha(30)),
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        ProfileImageGenerator(
                                          seed: user.image,
                                          size: 35,
                                          username: user.username,
                                        ),
                                        Expanded(
                                          child: Text(
                                            user.username,
                                            style: TextStyle(
                                                color: colors.tertiary,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                          _transaction?.offer != null
                              ? RippleWrapper(
                                  onPressed: () {
                                    openModal(
                                        context,
                                        OfferInfoModal(
                                            offer: _transaction!.offer!));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: colors.tertiaryContainer
                                            .withAlpha(30)),
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        ImageComponent(
                                          image: _transaction!
                                              .offer!.partner.image,
                                          size: 35,
                                          borderRadius: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${_transaction!.offer!.partner.name} - ${_transaction!.offer!.catchString}',
                                            style: TextStyle(
                                                color: colors.tertiary,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _transactionType == TRANSACTION_TYPE.REDEEM
                        ? StreamBuilder<IAllClaimsData>(
                            stream: claimsController.allClaimsStream,
                            builder: (context, snapshot) {
                              final foundClaim =
                                  (snapshot.data?.content.values ?? [])
                                      .where((element) =>
                                          element.offer.id ==
                                          _transaction?.offer?.id)
                                      .firstOrNull;

                              if (foundClaim == null) {
                                return SizedBox.shrink();
                              }
                              return CopyText(textToCopy: foundClaim.code);
                            })
                        : SizedBox.shrink()
                  ]),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: MainButton(
                label: 'Close',
                backgroundColor: colors.tertiaryContainer.withAlpha(40),
                textColor: colors.primaryFixedDim,
                onPressed: () {
                  closeModal(context);
                }),
          )
        ],
      ),
    );
  }
}
