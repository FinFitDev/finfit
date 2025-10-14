import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/shop/transaction/requests.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

const TRANSACTION_DATA_CHUNK_SIZE = 5; // TODO change

class TransactionsController {
  final BehaviorSubject<ContentWithLoading<Map<String, ITransactionEntry>>>
      _allTransactions =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, ITransactionEntry>>>
      get allTransactionsStream => _allTransactions.stream;
  ContentWithLoading<Map<String, ITransactionEntry>> get allTransactions =>
      _allTransactions.value;

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  bool get canFetchMore => _canFetchMore.value;
}

TransactionsController transactionsController = TransactionsController();
