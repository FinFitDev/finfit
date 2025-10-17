import 'package:excerbuys/components/dashboard_page/home_page/transaction_card/transaction_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/transaction_info_modal.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/transaction/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
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
  List<ITransactionEntry> _transactions = [];

  void _prepareTransactions() {
    final sortedTransactions = widget.recentTransactions.values
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    setState(() {
      _transactions = sortedTransactions;
    });
  }

  @override
  void initState() {
    super.initState();

    _prepareTransactions();
  }

  @override
  void didUpdateWidget(covariant TransactionsSection oldWidget) {
    if (oldWidget.recentTransactions != widget.recentTransactions) {
      _prepareTransactions();
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
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transactionData = _transactions[index];
                return Container(
                  margin: EdgeInsets.only(top: index != 0 ? 8 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colors.primaryContainer,
                  ),
                  child: TransactionCard(
                    points: transactionData.amountPoints?.round() ?? 0,
                    onPressed: () {
                      openModal(
                          context,
                          TransactionInfoModal(
                              transactionId: transactionData.uuid));
                    },
                    date: transactionData.createdAt,
                    type: transactionTypeStringToEnum(transactionData.type),
                    offerImage: transactionData.offer?.partner.image,
                    offerName:
                        '${transactionData.offer?.partner.name} - ${transactionData.offer?.catchString}',
                    userInfo: transactionData.secondUsers,
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
          UniversalLoaderBox(height: 80),
          UniversalLoaderBox(height: 70),
          UniversalLoaderBox(height: 70),
          UniversalLoaderBox(height: 70),
          UniversalLoaderBox(height: 70),
        ],
      ));
}
