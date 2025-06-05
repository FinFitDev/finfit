import 'dart:convert';
import 'dart:math';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/user.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:rxdart/rxdart.dart';

part 'mutations.dart';
part 'selectors.dart';
part 'effects.dart';

class UserController {
  final BehaviorSubject<User?> _currentUser = BehaviorSubject.seeded(null);
  Stream<User?> get currentUserStream => _currentUser.stream;
  User? get currentUser => _currentUser.value;
}

UserController userController = UserController();
