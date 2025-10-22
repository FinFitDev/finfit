part of 'transactions_controller.dart';

extension TransactionsControllerEffects on TransactionsController {
  Future<void> fetchTransactions() async {
    try {
      if (allTransactions.isLoading) {
        return;
      }

      setTransactionsLoading(true);

      final List<ITransactionEntry>? fetchedTransactions =
          await loadTransactionRequest(
              userController.currentUser!.uuid, TRANSACTION_DATA_CHUNK_SIZE, 0);

      if (fetchedTransactions == null || fetchedTransactions.isEmpty) {
        throw 'No transactions found';
      }

      final Map<String, ITransactionEntry> transactionsMap = {
        for (final el in fetchedTransactions) el.uuid: el
      };

      addTransactions(transactionsMap);

      offersController.addAllOffers(extractNewOffersFromTransactions(
          transactionsMap, offersController.allOffers.content));

      // it means we are at the end of the data
      if (transactionsMap.length < TRANSACTION_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
      setLazyLoadOffset(allTransactions.content.length);
    } catch (error) {
      print(error);
    } finally {
      setTransactionsLoading(false);
    }
  }

  Future<void> lazyLoadMoreTransactions() async {
    try {
      if (userController.currentUser?.uuid == null) {
        throw Exception('Current user is null');
      }
      setLoadingMoreData(true);

      List<ITransactionEntry> parsedTransactionData =
          await loadTransactionRequest(userController.currentUser!.uuid,
                  TRANSACTION_DATA_CHUNK_SIZE, lazyLoadOffset.content) ??
              [];
      Set<String> unique = {};
      parsedTransactionData = parsedTransactionData
          .where((element) => unique.add(element.uuid))
          .toList();

      Map<String, ITransactionEntry> values = {
        for (var el in parsedTransactionData) el.uuid: el,
      };

      addTransactions(values);
      offersController.addAllOffers(extractNewOffersFromTransactions(
          values, offersController.allOffers.content));
      // it means we are at the end of the data
      if (values.length < TRANSACTION_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
      setLazyLoadOffset(allTransactions.content.length);
    } catch (error) {
      debugPrint("Exception while lazy loading more transaction data: $error");
    } finally {
      setLoadingMoreData(false);
    }
  }
}
