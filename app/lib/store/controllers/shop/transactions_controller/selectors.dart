part of 'transactions_controller.dart';

extension TransactionsControllerSelectors on TransactionsController {
  Stream<ContentWithLoading<Map<String, ITransactionEntry>>>
      get sortedTransactions {
    return allTransactionsStream.map(getSortedRecentTransactions);
  }
}
