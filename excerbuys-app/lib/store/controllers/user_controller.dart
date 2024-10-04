import 'dart:convert';

import 'package:excerbuys/store/controllers/app_controller.dart';
import 'package:excerbuys/store/persistance/storage_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

class UserController {
  final BehaviorSubject<User?> _currentUser = BehaviorSubject.seeded(null);
  Stream<User?> get currentUserStream => _currentUser.stream;
  User? get currentUser => _currentUser.value;
  setCurrentUser(User? user) {
    if (user != null) {
      _currentUser.add(user);
      storageController.saveState('current_user', user.toString());
    }
  }

  restoreCurrentUserStateFromStorage() async {
    try {
      final String? currentUserSaved =
          await storageController.loadState('current_user');

      if (currentUserSaved != null && currentUserSaved.isNotEmpty) {
        setCurrentUser(User.fromMap(jsonDecode(currentUserSaved)));
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  Future<User?> fetchCurrentUser(String userId) async {
    try {
      dynamic res = await BackendUtils.handleBackendRequests(
          method: HTTP_METHOD.GET, endpoint: 'api/v1/users/$userId');

      final content = res['content'];

      if (content == null || content.isEmpty) {
        throw 'No data';
      }

      print(content);
      final User user = User(
          id: int.parse(content['id']),
          email: content['email'],
          username: content['username'],
          createdAt: DateTime.parse(content['created_at']).toLocal(),
          updatedAt: DateTime.parse(content['updated_at']).toLocal(),
          points: (content['points'] as int).toDouble(),
          image: content['image']);
      setCurrentUser(user);

      return user;
    } catch (err) {
      print(err);
    }
  }

  Future<bool> updatePointsScore(String accessToken, String userId, int points,
      DateTime updated_at) async {
    print('$points totlllll');
    try {
      if (accessToken.isEmpty) {
        throw 'Not authorized';
      }
      Response res = await post(
          Uri.parse('${GeneralConstants.BACKEND_BASE_URL}api/v1/users/$userId'),
          body: {
            "points": points.toString(),
            "updated_at": updated_at.toString()
          },
          headers: {
            "authorization": "Bearer $accessToken"
          });

      var data = jsonDecode(res.body);
      print(data);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

UserController userController = UserController();
