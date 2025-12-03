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

  final BehaviorSubject<bool?> _trackingPlayed = BehaviorSubject.seeded(null);
  Stream<bool?> get trackingPlayedStream => _trackingPlayed.stream;
  bool? get trackingPlayed => _trackingPlayed.value;
}

DashboardController dashboardController = DashboardController();
