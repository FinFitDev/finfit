import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/selectors/activity/trainings.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/requests.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/enums.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

const TRAINING_DATA_CHUNK_SIZE = 5; // TODO change

class TrainingsController {
  final BehaviorSubject<ContentWithLoading<Map<int, ITrainingEntry>>>
      _userTrainings = BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<int, ITrainingEntry>>>
      get userTrainingsStream => _userTrainings.stream;
  ContentWithLoading<Map<int, ITrainingEntry>> get userTrainings =>
      _userTrainings.value;

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;

  final BehaviorSubject<bool> _isTracking = BehaviorSubject.seeded(false);
  Stream<bool> get isTrackingStream => _isTracking.stream;
  bool get isTracking => _isTracking.value;

  final BehaviorSubject<bool> _isInserting = BehaviorSubject.seeded(false);
  Stream<bool> get isInsertingStream => _isInserting.stream;
  bool get isInserting => _isInserting.value;
}

TrainingsController trainingsController = TrainingsController();
