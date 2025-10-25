import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<List<ITransactionEntry>?> loadTransactionRequest(
    String userId, int? limit, int? offset) async {
  Future<List<ITransactionEntry>?> handler() async {
    final List<ITransactionEntry> result = [];
    try {
      final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/transactions/$userId?limit=$limit&offset=$offset',
      );

      if (res['error'] != null) {
        throw res['error'];
      }

      final content = res['content'];

      for (final el in content) {
        result.add(ITransactionEntry.fromJson(el));
      }
      return result;
    } catch (error) {
      print('Error loading transactions from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<ITransactionEntry>?>(
      "${BACKEND_BASE_URL}api/v1/transactions/$userId?limit=$limit&offset=$offset",
      () async => await handler(),
      (list) => (list ?? []).map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return ITransactionEntry.fromJson(e);
          }).toList());
}
