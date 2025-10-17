import 'package:excerbuys/types/user.dart';

double? getBalance(User? user) {
  return user?.points;
}

double? getTotalPointsEarned(User? user) {
  return user?.totalPointsEarned;
}
