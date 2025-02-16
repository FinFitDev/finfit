import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/app_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/trainings.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

class TrainingsController {
  final BehaviorSubject<ContentWithLoading<Map<String, ITrainingEntry>>>
      _userTrainings = BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, ITrainingEntry>>>
      get userTrainingsStream => _userTrainings.stream;
  ContentWithLoading<Map<String, ITrainingEntry>> get userTrainings =>
      _userTrainings.value;
  addUserTrainings(Map<String, ITrainingEntry> activity) {
    Map<String, ITrainingEntry> newTrainings = {
      ...userTrainings.content,
      ...activity
    };
    _userTrainings.add(ContentWithLoading(content: newTrainings));
  }

  setTrainingsLoading(bool loading) {
    userTrainings.isLoading = loading;
    _userTrainings.add(userTrainings);
  }

  final BehaviorSubject<int> _lazyLoadOffset = BehaviorSubject.seeded(0);
  Stream<int> get lazyLoadOffsetStream => _lazyLoadOffset.stream;
  int get lazyLoadOffset => _lazyLoadOffset.value;
  addLazyLoadOffset(int offsetToAdd) {
    _lazyLoadOffset.add(lazyLoadOffset + offsetToAdd);
  }

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;
  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }

  Future<void> fetchTrainings() async {
    final now = DateTime.now();
    final userCreated = userController.currentUser?.createdAt ?? now;
    final installTimestamp = appController.installTimestamp;
    final Duration differenceUserCreated = now.difference(userCreated);
    final Duration differenceInstallApp = now.difference(installTimestamp);
    final Duration maxDifference = Duration(days: 90);

    // Use the smallest of the three:
    // up to 90 days (we only fetch max up to 3 months of tainings backwards)
    // up to app install date
    // up to user creation date
    final Duration limitedDifference = [
      // TODO: uncomment when we have finished testing
      // differenceInstallApp,
      differenceUserCreated,
      maxDifference,
    ].reduce((a, b) => a.compareTo(b) < 0 ? a : b);

    final prev = now.subtract(limitedDifference);

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: prev,
        endTime: now,
      );
      healthData = filterTrainings(Health().removeDuplicates(healthData));

      List<ITrainingEntry> parsedTrainingData =
          convertTrainingsToRequest(healthData) ?? [];

      final pointsAwardedResponse = await saveTrainings(parsedTrainingData);
      if (pointsAwardedResponse != null) {
        activityController
            .compundPointsToAdd(double.parse(pointsAwardedResponse));
      }

      if (userController.currentUser?.id != null) {
        parsedTrainingData =
            await loadTrainings(userController.currentUser!.id, 5, 0) ?? [];

        Set<String> unique = {};
        parsedTrainingData = parsedTrainingData
            .where((element) => unique.add(element.uuid))
            .toList();
      }

      Map<String, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.uuid: el,
      };

      addUserTrainings(values);
      setTrainingsLoading(false);

      // it means we are at the end of the data
      if (values.length < 5) {
        setCanFetchMore(false);
      }
    } catch (error) {
      debugPrint("Exception while extracting trainings data: $error");
    }
  }

  Future<void> lazyLoadMoreTrainings() async {
    try {
      if (userController.currentUser?.id == null) {
        throw Exception('Current user is null');
      }

      List<ITrainingEntry> parsedTrainingData = await loadTrainings(
              userController.currentUser!.id, 5, lazyLoadOffset) ??
          [];

      Set<String> unique = {};
      parsedTrainingData = parsedTrainingData
          .where((element) => unique.add(element.uuid))
          .toList();

      Map<String, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.uuid: el,
      };

      if (values.isNotEmpty) {
        addUserTrainings(values);
        addLazyLoadOffset(5);
      }

      // it means we are at the end of the data
      if (values.length < 5) {
        setCanFetchMore(false);
      }
    } catch (error) {
      debugPrint("Exception while lazy loading more trainings data: $error");
    }
  }
}

TrainingsController trainingsController = TrainingsController();
