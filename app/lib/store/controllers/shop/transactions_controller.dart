import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/selectors/shop/products.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/shop/product/requests.dart';
import 'package:excerbuys/utils/shop/transaction/requests.dart';
import 'package:rxdart/rxdart.dart';

class TransactionsController {
  reset() {
    _allTransactions.add(ContentWithLoading(content: {}));
    setTransactionsLoading(false);
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

  Future<void> fetchTransactions() async {
    try {
      if (allTransactions.isLoading) {
        return;
      }

      setTransactionsLoading(true);

      final List<ITransactionEntry>? fetchedTransactions =
          await loadTransactionRequest(userController.currentUser!.uuid);

      if (fetchedTransactions == null || fetchedTransactions.isEmpty) {
        throw 'No transactions found';
      }

      final Map<String, ITransactionEntry> transactionsMap = {
        for (final el in fetchedTransactions) el.uuid: el
      };

      addTransactions(transactionsMap);
    } catch (error) {
      print(error);
    } finally {
      setTransactionsLoading(false);
    }
  }
}

TransactionsController transactionsController = TransactionsController();
