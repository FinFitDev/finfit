import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class ModalContentWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const ModalContentWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MODAL_BORDER_RADIUS),
            topRight: Radius.circular(MODAL_BORDER_RADIUS)),
        child: Container(
            height: MediaQuery.sizeOf(context).height * 0.9,
            color: colors.primary,
            width: double.infinity,
            padding: padding ??
                EdgeInsets.only(
                    left: HORIZOTAL_PADDING,
                    right: HORIZOTAL_PADDING,
                    bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
            child: child));
  }
}
