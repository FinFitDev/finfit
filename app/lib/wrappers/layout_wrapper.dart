import 'dart:io';

import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:flutter/material.dart';

class LayoutWrapper extends StatefulWidget {
  final Widget child;
  const LayoutWrapper({super.key, required this.child});

  @override
  State<LayoutWrapper> createState() => _LayoutWrapperState();
}

class _LayoutWrapperState extends State<LayoutWrapper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // set content width for the inner application
    layoutController.setRelativeConetntWidth(MediaQuery.sizeOf(context).width);

    // set content height for the inner application taking into account the padding
    layoutController
        .setRelativeConetntHeight(MediaQuery.sizeOf(context).height);

    // set height of the bottom padding based on user platform
    layoutController.setBottomPadding(Platform.isIOS ? 25 : 0);

    return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        // color: Theme.of(context).colorScheme.secondary.withAlpha(40),
        child: Stack(
          children: [
            StreamBuilder<int>(
                stream: layoutController.modalOpenCountStream,
                builder: (context, snapshot) {
                  return AnimatedScale(
                      scale: (snapshot.data ?? 0) > 0 ? 0.90 : 1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.decelerate,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              (snapshot.data ?? 0) > 0 ? 20 : 0),
                          child: widget.child));
                }),
          ],
        ));
  }
}
