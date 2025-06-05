import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';

class ModalContentWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final void Function()? onClose;
  final void Function()? onClickBack;

  final EdgeInsets? padding;
  const ModalContentWrapper(
      {super.key,
      required this.child,
      this.padding,
      this.title,
      this.subtitle,
      this.onClose,
      this.onClickBack});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MODAL_BORDER_RADIUS),
            topRight: Radius.circular(MODAL_BORDER_RADIUS)),
        child: Container(
            height: MediaQuery.sizeOf(context).height * 0.92,
            color: colors.primary,
            width: double.infinity,
            child: Column(
              children: [
                title != null && subtitle != null
                    ? ModalHeader(
                        title: title!,
                        subtitle: subtitle!,
                        onClose: onClose,
                        goBack: onClickBack,
                      )
                    : SizedBox.shrink(),
                Expanded(
                    child: Padding(
                  padding: padding ??
                      EdgeInsets.only(
                          left: HORIZOTAL_PADDING,
                          right: HORIZOTAL_PADDING,
                          bottom: layoutController.bottomPadding +
                              HORIZOTAL_PADDING),
                  child: child,
                )),
              ],
            )));
  }
}
