import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/shop/transaction/requests.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const TRANSACTION_DATA_CHUNK_SIZE = 5; // TODO change

class TransactionsController {
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

  final BehaviorSubject<ContentWithLoading<Map<String, ITransactionEntry>>>
      _allTransactions =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, ITransactionEntry>>>
      get allTransactionsStream => _allTransactions.stream;
  ContentWithLoading<Map<String, ITransactionEntry>> get allTransactions =>
      _allTransactions.value;

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

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;
  setLazyLoadOffset(int newOffset) {
    final newData = ContentWithLoading(content: newOffset);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newData);
  }

  setLoadingMoreData(bool loading) {
    lazyLoadOffset.isLoading = loading;
    _lazyLoadOffset.add(lazyLoadOffset);
  }

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  bool get canFetchMore => _canFetchMore.value;
  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }

  Future<void> fetchTransactions() async {
    try {
      if (allTransactions.isLoading) {
        return;
      }

      setTransactionsLoading(true);
      await Future.delayed(Duration(milliseconds: 2000)); // TODO remove

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
      await Future.delayed(Duration(milliseconds: 2000)); // TODO remove

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

      if (values.isNotEmpty) {
        addTransactions(values);
        productsController.addProducts({
          for (final entry in values.entries)
            if (entry.value.product != null)
              entry.value.product!.uuid: entry.value.product!
        });
        setLazyLoadOffset(allTransactions.content.length);
      }

      // it means we are at the end of the data
      if (values.length < TRANSACTION_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
    } catch (error) {
      debugPrint("Exception while lazy loading more transaction data: $error");
    } finally {
      setLoadingMoreData(false);
    }
  }
}

TransactionsController transactionsController = TransactionsController();
