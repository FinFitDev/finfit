part of 'dashboard_controller.dart';

extension DashboardControllerMutations on DashboardController {
  reset() {
    setActivePage(0);
    setScrollDistance(0);
    setBalanceHidden(false);
  }

  setActivePage(int index) {
    _activePage.add(index);
  }

  setScrollDistance(double distance) {
    _scrollDistance.add(distance);
  }

  setBalanceHidden(bool value) {
    _balanceHidden.add(value);
  }
}
