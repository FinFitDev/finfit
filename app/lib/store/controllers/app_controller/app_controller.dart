import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

part 'mutations.dart';
part 'selectors.dart';
part 'effects.dart';

class AppController {
  final BehaviorSubject<String> _deviceId =
      BehaviorSubject.seeded('unknown_device');
  Stream<String> get deviceIdStream => _deviceId.stream;
  String get deviceId => _deviceId.value;

  final BehaviorSubject<DateTime> _installTimestamp =
      BehaviorSubject.seeded(DateTime.now());
  Stream<DateTime> get installTimestampStream => _installTimestamp.stream;
  DateTime get installTimestamp => _installTimestamp.value;
}

AppController appController = AppController();
