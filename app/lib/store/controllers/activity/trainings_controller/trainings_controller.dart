import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/app_controller/app_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/requests.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:excerbuys/utils/activity/trainings.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

const TRAINING_DATA_CHUNK_SIZE = 5; // TODO change

class TrainingsController {
  final BehaviorSubject<ContentWithLoading<Map<String, ITrainingEntry>>>
      _userTrainings = BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, ITrainingEntry>>>
      get userTrainingsStream => _userTrainings.stream;
  ContentWithLoading<Map<String, ITrainingEntry>> get userTrainings =>
      _userTrainings.value;

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;
}

TrainingsController trainingsController = TrainingsController();
