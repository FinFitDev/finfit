import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';
part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

class StepsController {
  final BehaviorSubject<ContentWithLoading<IStoreStepsData>> _userSteps =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<IStoreStepsData>> get userStepsStream =>
      _userSteps.stream;
  ContentWithLoading<IStoreStepsData> get userSteps => _userSteps.value;
}

StepsController stepsController = StepsController();
