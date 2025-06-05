import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/auth/requests.dart';
import 'package:excerbuys/utils/constants.dart';

import 'package:rxdart/rxdart.dart';

part 'mutations.dart';
part 'selectors.dart';
part 'effects.dart';

class AuthController {
  final BehaviorSubject<AUTH_METHOD> _activeAuthMethod =
      BehaviorSubject.seeded(AUTH_METHOD.LOGIN);
  Stream<AUTH_METHOD> get activeAuthMethodStream => _activeAuthMethod.stream;
  AUTH_METHOD get activeAuthMethod => _activeAuthMethod.value;

  // access token state
  final BehaviorSubject<String> _accessToken = BehaviorSubject.seeded('');
  Stream<String> get accessTokenStream => _accessToken.stream;
  String get accessToken => _accessToken.value;

  // refresh token state
  final BehaviorSubject<String> _refreshToken = BehaviorSubject.seeded('');
  Stream<String> get refreshTokenStream => _refreshToken.stream;
  String get refreshToken => _refreshToken.value;

  // verify user is necessary
  final BehaviorSubject<UserToVerify?> _userToVerify =
      BehaviorSubject.seeded(null);
  Stream<UserToVerify?> get userToVerifyStream => _userToVerify.stream;
  UserToVerify? get userToVerify => _userToVerify.value;

  final BehaviorSubject<ResetPasswordUser?> _resetPasswordUser =
      BehaviorSubject.seeded(null);
  Stream<ResetPasswordUser?> get resetPasswordUserStream =>
      _resetPasswordUser.stream;
  ResetPasswordUser? get resetPasswordUser => _resetPasswordUser.value;
}

AuthController authController = AuthController();
