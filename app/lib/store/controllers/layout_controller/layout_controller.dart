import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'mutations.dart';

class LayoutController {
  final BehaviorSubject<double> _statusBarHeight = BehaviorSubject.seeded(0.0);
  Stream<double> get statusBarHeightStream => _statusBarHeight.stream;
  double get statusBarHeight => _statusBarHeight.value;

  final BehaviorSubject<double> _bottomPadding = BehaviorSubject.seeded(0.0);
  Stream<double> get bottomPaddingStream => _bottomPadding.stream;
  double get bottomPadding => _bottomPadding.value;

  final BehaviorSubject<double> _relativeContentHeight =
      BehaviorSubject.seeded(0.0);
  Stream<double> get relativeContentHeightStream =>
      _relativeContentHeight.stream;
  double get relativeContentHeight => _relativeContentHeight.value;

  final BehaviorSubject<double> _relativeContentWidth =
      BehaviorSubject.seeded(0.0);
  Stream<double> get relativeContentWidthStream => _relativeContentWidth.stream;
  double get relativeContentWidth => _relativeContentWidth.value;

  final BehaviorSubject<int> _modalOpenCount = BehaviorSubject.seeded(0);
  Stream<int> get modalOpenCountStream => _modalOpenCount.stream;
  int get modalOpenCount => _modalOpenCount.value;

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
