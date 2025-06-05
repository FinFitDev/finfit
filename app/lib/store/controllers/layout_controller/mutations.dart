part of 'layout_controller.dart';

extension LayoutControllerMutations on LayoutController {
  setStatusBarHeight(double val) {
    _statusBarHeight.add(val);
  }

  setBottomPadding(double val) {
    _bottomPadding.add(val);
  }

  setRelativeConetntHeight(double val) {
    _relativeContentHeight.add(val);
  }

  setRelativeConetntWidth(double val) {
    _relativeContentWidth.add(val);
  }

  addModalOpenCount() {
    _modalOpenCount.add(modalOpenCount + 1);
  }

  subtractModalOpenCount() {
    _modalOpenCount.add(modalOpenCount - 1 > 0 ? modalOpenCount - 1 : 0);
  }
}
