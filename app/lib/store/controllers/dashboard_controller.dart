import 'package:rxdart/rxdart.dart';

class DashboardController {
  final BehaviorSubject<int> _activePage = BehaviorSubject.seeded(0);
  Stream<int> get activePageStream => _activePage.stream;
  int get activePage => _activePage.value;
  setActivePage(int index) {
    _activePage.add(index);
  }

  final BehaviorSubject<double> _scrollDistance = BehaviorSubject.seeded(0);
  Stream<double> get scrollDistanceStream => _scrollDistance.stream;
  double get scrollDistance => _scrollDistance.value;
  setScrollDistance(double distance) {
    _scrollDistance.add(distance);
  }

  final BehaviorSubject<bool> _balanceHidden = BehaviorSubject.seeded(false);
  Stream<bool> get balanceHiddenStream => _balanceHidden.stream;
  bool get balanceHidden => _balanceHidden.value;
  setBalanceHidden(bool value) {
    _balanceHidden.add(value);
  }

  reset() {
    setActivePage(0);
    setScrollDistance(0);
    setBalanceHidden(false);
  }
}

DashboardController dashboardController = DashboardController();
