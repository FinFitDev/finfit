import 'dart:io';

import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:flutter/material.dart';

class LayoutWrapper extends StatefulWidget {
  final Widget child;
  const LayoutWrapper({super.key, required this.child});

  @override
  State<LayoutWrapper> createState() => _LayoutWrapperState();
}

class _LayoutWrapperState extends State<LayoutWrapper> {
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = Platform.isIOS ? 25 : 0;
    final double statusBarHeight = layoutController.statusBarHeight;

    // set content height for the inner application taking into account the padding
    layoutController.setRelativeConetntHeight(
        MediaQuery.sizeOf(context).height -
            bottomPadding -
            layoutController.statusBarHeight);

    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.only(top: statusBarHeight, bottom: bottomPadding),
      child: widget.child,
    );
  }
}
