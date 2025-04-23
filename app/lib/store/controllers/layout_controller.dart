import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LayoutController {
  final BehaviorSubject<double> _statusBarHeight = BehaviorSubject.seeded(0.0);
  Stream<double> get statusBarHeightStream => _statusBarHeight.stream;
  double get statusBarHeight => _statusBarHeight.value;
  setStatusBarHeight(double val) {
    _statusBarHeight.add(val);
  }

  final BehaviorSubject<double> _bottomPadding = BehaviorSubject.seeded(0.0);
  Stream<double> get bottomPaddingStream => _bottomPadding.stream;
  double get bottomPadding => _bottomPadding.value;
  setBottomPadding(double val) {
    _bottomPadding.add(val);
  }

  final BehaviorSubject<double> _relativeContentHeight =
      BehaviorSubject.seeded(0.0);
  Stream<double> get relativeContentHeightStream =>
      _relativeContentHeight.stream;
  double get relativeContentHeight => _relativeContentHeight.value;
  setRelativeConetntHeight(double val) {
    _relativeContentHeight.add(val);
  }

  final BehaviorSubject<double> _relativeContentWidth =
      BehaviorSubject.seeded(0.0);
  Stream<double> get relativeContentWidthStream => _relativeContentWidth.stream;
  double get relativeContentWidth => _relativeContentWidth.value;
  setRelativeConetntWidth(double val) {
    _relativeContentWidth.add(val);
  }

  // final BehaviorSubject<FocusNode> _focusNode =
  //     BehaviorSubject.seeded(FocusNode());
  // Stream<FocusNode> get focusNodeStream => _focusNode.stream;
  // FocusNode get focusNode => _focusNode.value;
  // setFocusNode(FocusNode node) {
  //   _focusNode.add(node);
  // }

  // unfocusNode() {
  //   if (_focusNode.value.hasFocus) {
  //     _focusNode.value.unfocus();
  //   }
  // }
}

LayoutController layoutController = LayoutController();
