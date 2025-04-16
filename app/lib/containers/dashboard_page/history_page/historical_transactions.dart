import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_indicator.dart';
import 'package:excerbuys/components/shared/indicators/circle_progress/load_more_indicator.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/transactions_section.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HistoricalTransactions extends StatefulWidget {
  final double? scrollLoadMoreProgress;
  const HistoricalTransactions({super.key, this.scrollLoadMoreProgress});

  @override
  State<HistoricalTransactions> createState() => _HistoricalTransactionsState();
}

class _HistoricalTransactionsState extends State<HistoricalTransactions> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        StreamBuilder<ContentWithLoading<Map<String, ITransactionEntry>>>(
            stream: transactionsController.allTransactionsStream,
            builder: (context, snapshot) {
              final Map<String, ITransactionEntry> transactions =
                  snapshot.hasData
                      ? Map.fromEntries(snapshot.data!.content.entries.toList())
                      : {};
              return TransactionsSection(
                isLoading: snapshot.data?.isLoading ?? false,
                recentTransactions: transactions,
                hideTitle: true,
              );
            }),
      ],
    );
  }
}
