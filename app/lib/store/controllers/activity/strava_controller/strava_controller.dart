import 'dart:convert';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/utils/activity/requests.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:rxdart/rxdart.dart';

part 'mutations.dart';
part 'effects.dart';
part 'selectors.dart';

class StravaController {
  final BehaviorSubject<bool> _authorized = BehaviorSubject.seeded(false);
  Stream<bool> get authorizedStream => _authorized.stream;
  bool get authorized => _authorized.value;

  final BehaviorSubject<bool> _enabled = BehaviorSubject.seeded(false);
  Stream<bool> get enabledStream => _enabled.stream;
  bool get enabled => _enabled.value;

  final BehaviorSubject<bool> _updatingPermission =
      BehaviorSubject.seeded(false);
  Stream<bool> get updatingPermissionStream => _updatingPermission.stream;
  bool get updatingPermission => _updatingPermission.value;
}

StravaController stravaController = StravaController();
