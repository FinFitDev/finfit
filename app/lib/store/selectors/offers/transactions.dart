import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/utils.dart';

ContentWithLoading<Map<String, ITransactionEntry>> getSortedRecentTransactions(
  ContentWithLoading<Map<String, ITransactionEntry>> all,
) {
  final sortedTransactions = getTopRecentEntries(
      all.content, (a, b) => b.value.createdAt.compareTo(a.value.createdAt), 5);
  final ContentWithLoading<Map<String, ITransactionEntry>> response =
      ContentWithLoading(content: sortedTransactions);
  response.isLoading = all.isLoading;
  return response;
}
