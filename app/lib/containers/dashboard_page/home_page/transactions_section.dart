import 'package:excerbuys/components/dashboard_page/home_page/transaction_card/transaction_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/transaction_info_modal.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/transaction/utils.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:flutter/material.dart';

class TransactionsSection extends StatefulWidget {
  final Map<String, ITransactionEntry> recentTransactions;
  final bool? isLoading;
  final bool? isDaily;
  final bool? hideTitle;
  final bool? allowLoadMore;

  const TransactionsSection(
      {super.key,
      required this.recentTransactions,
      this.isLoading,
      this.isDaily,
      this.hideTitle,
      this.allowLoadMore});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  Map<String, List<ITransactionEntry>> _groupedTransactionsData = {};

  void groupData() {
    if (widget.recentTransactions.isEmpty) {
      return;
    }

    final Map<String, List<ITransactionEntry>> groupedData = {};
    for (var el in widget.recentTransactions.values) {
      final List<String> splitParsedDate = parseDate(el.createdAt).split(' ');
      final String dateKey = splitParsedDate.length == 3
          ? '${splitParsedDate[0]} ${splitParsedDate[1]}'
          : splitParsedDate[0];

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final elementTimestampDay =
          DateTime(el.createdAt.year, el.createdAt.month, el.createdAt.day);
      groupedData
          .putIfAbsent(
              '${dateKey}_${today.difference(elementTimestampDay).inDays}',
              () => [])
          .add(el);
    }

    setState(() {
      _groupedTransactionsData = groupedData;
    });
  }

  @override
  void initState() {
    super.initState();

    groupData();
  }

  @override
  void didUpdateWidget(covariant TransactionsSection oldWidget) {
    if (oldWidget.recentTransactions != widget.recentTransactions) {
      groupData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Builder(builder: (BuildContext context) {
      if (widget.recentTransactions.isEmpty && widget.isLoading != true) {
        return emptyActivity(
            colors, texts, widget.isDaily ?? false, widget.hideTitle ?? false);
      }

      return Container(
        margin: EdgeInsets.only(
            left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING, bottom: 24),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          widget.hideTitle == true
              ? SizedBox.shrink()
              : Text(
                  widget.isDaily == true
                      ? 'Daily transactions'
                      : 'Last transactions',
                  style: texts.headlineLarge,
                ),
          Builder(builder: (context) {
            if (widget.isLoading == true) {
              return loadingTransactions(widget.hideTitle ?? false);
            }
            return ListView.builder(
              padding: EdgeInsets.only(top: widget.hideTitle == true ? 0 : 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _groupedTransactionsData.length,
              itemBuilder: (context, index) {
                final entry = _groupedTransactionsData.entries.elementAt(index);
                final keyParts = entry.key.split('_');
                final dateLabel = keyParts[0];
                final daysAgo = keyParts.length > 1 ? keyParts[1] : '';

                return Container(
                  margin: EdgeInsets.only(top: index != 0 ? 8 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.isDaily != true)
                        Container(
                          margin: EdgeInsets.only(top: 4, bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                dateLabel,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colors.tertiaryContainer),
                              ),
                              SizedBox(width: 6),
                              if (dateLabel != 'Today' &&
                                  dateLabel != 'Yesterday')
                                Text(
                                  '($daysAgo days ago)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: colors.tertiaryContainer
                                          .withAlpha(150)),
                                ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  height: 0,
                                  color:
                                      colors.tertiaryContainer.withAlpha(100),
                                ),
                              )
                            ],
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.primaryContainer,
                        ),
                        child: Column(
                          children: entry.value.map((transactionData) {
                            return TransactionCard(
                              points:
                                  transactionData.amountFinpoints?.round() ??
                                      transactionData.product?.finpointsPrice
                                          .round() ??
                                      0,
                              onPressed: () {
                                openModal(
                                    context,
                                    TransactionInfoModal(
                                        transactionId: transactionData.uuid));
                              },
                              date: parseDate(transactionData.createdAt),
                              type: transactionTypeStringToEnum(
                                  transactionData.type),
                              productImage: transactionData.product?.image,
                              productPrice: transactionData.product != null
                                  ? (transactionData.product!.originalPrice *
                                      (1 -
                                          (transactionData.product!.discount) /
                                              100))
                                  : null,
                              userImage: transactionData.secondUser?.image,
                              username: transactionData.secondUser?.username,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ]),
      );
    });
  }
}

Widget emptyActivity(
    ColorScheme colors, TextTheme texts, bool isDaily, bool hideTitle) {
  return Container(
    margin: EdgeInsets.only(
        left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING, bottom: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            isDaily == true ? 'Daily transactions' : 'No transactions yet',
            textAlign: TextAlign.start,
            style: texts.headlineLarge,
          ),
        ),
        Text(
          textAlign: TextAlign.start,
          isDaily == true
              ? 'Could not find transactions for the selected date. '
              : 'Start working out to earn finpoints and claim your discounts in the shop!',
          style: TextStyle(
            color: colors.primaryFixedDim,
          ),
        ),
      ],
    ),
  );
}

Widget loadingTransactions(bool hideTitle) {
  return Container(
      margin: EdgeInsets.only(top: hideTitle ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UniversalLoaderBox(
            height: 20,
            width: 200,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70),
          SizedBox(
            height: 16,
          ),
          UniversalLoaderBox(
            height: 20,
            width: 150,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70),
          SizedBox(
            height: 16,
          ),
          UniversalLoaderBox(
            height: 20,
            width: 250,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70),
          SizedBox(
            height: 16,
          ),
          UniversalLoaderBox(
            height: 20,
            width: 150,
          ),
          SizedBox(
            height: 8,
          ),
          UniversalLoaderBox(height: 70),
        ],
      ));
}
