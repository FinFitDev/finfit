part of 'transactions_controller.dart';

extension TransactionsControllerMutations on TransactionsController {
  reset() {
    final newData =
        ContentWithLoading(content: Map<String, ITransactionEntry>());
    newData.isLoading = allTransactions.isLoading;
    _allTransactions.add(newData);

    _canFetchMore.add(true);

    final newLazyLoadData = ContentWithLoading(content: 0);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newLazyLoadData);
  }

  refresh() {
    reset();
    fetchTransactions();
  }

  addTransactions(Map<String, ITransactionEntry> transactions) {
    Map<String, ITransactionEntry> newTransactions = {
      ...allTransactions.content,
      ...transactions
    };
    final newData = ContentWithLoading(content: newTransactions);
    newData.isLoading = allTransactions.isLoading;
    _allTransactions.add(newData);
  }

  setTransactionsLoading(bool loading) {
    allTransactions.isLoading = loading;
    _allTransactions.add(allTransactions);
  }

  setLazyLoadOffset(int newOffset) {
    final newData = ContentWithLoading(content: newOffset);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newData);
  }

  setLoadingMoreData(bool loading) {
    lazyLoadOffset.isLoading = loading;
    _lazyLoadOffset.add(lazyLoadOffset);
  }

  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }
}
