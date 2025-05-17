import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/send.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/home/send/requests.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

class SendController {
  CancelToken cancelToken = CancelToken();

  final BehaviorSubject<ContentWithLoading<Map<String, User>>> _userList =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));

  Stream<ContentWithLoading<Map<String, User>>> get userListStream =>
      _userList.stream;

  ContentWithLoading<Map<String, User>> get userList => _userList.value;

  final BehaviorSubject<String?> _searchValue = BehaviorSubject.seeded(null);
  Stream<String?> get searchValueStream => _searchValue.stream;
  String? get searchValue => _searchValue.value;

  final BehaviorSubject<List<String>> _chosenUsersIds =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get chosenUsersIdsStream => _chosenUsersIds.stream;
  List<String> get chosenUsersIds => _chosenUsersIds.value;

  final BehaviorSubject<List<String>> _recentRecipientsIds =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get recentRecipientsIdsStream =>
      _recentRecipientsIds.stream;
  List<String> get recentRecipientsIds => _recentRecipientsIds.value;

  final BehaviorSubject<int?> _amount = BehaviorSubject.seeded(null);
  Stream<int?> get amountStream => _amount.stream;
  int? get amount => _amount.value;
}

SendController sendController = SendController();
