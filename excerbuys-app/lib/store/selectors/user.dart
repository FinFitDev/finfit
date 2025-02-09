import 'package:excerbuys/types/user.dart';

double? getBalance(User? user) {
  // if (user == null) {
  //   return 0;
  // }
  return user?.points;
}
