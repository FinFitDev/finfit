import 'package:rxdart/rxdart.dart';

part 'mutations.dart';

class DashboardController {
  final BehaviorSubject<int> _activePage = BehaviorSubject.seeded(0);
  Stream<int> get activePageStream => _activePage.stream;
  int get activePage => _activePage.value;

  final BehaviorSubject<double> _scrollDistance = BehaviorSubject.seeded(0);
  Stream<double> get scrollDistanceStream => _scrollDistance.stream;
  double get scrollDistance => _scrollDistance.value;

  final BehaviorSubject<bool> _balanceHidden = BehaviorSubject.seeded(false);
  Stream<bool> get balanceHiddenStream => _balanceHidden.stream;
  bool get balanceHidden => _balanceHidden.value;
}

DashboardController dashboardController = DashboardController();
