import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

Future<T?> openModal<T>(BuildContext context, Widget component,
    {void Function()? onClose, bool isFullHeight = true}) async {
  if (isFullHeight) layoutController.addModalOpenCount();

  FocusScope.of(context).requestFocus(FocusNode());

  final result = await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(MODAL_BORDER_RADIUS),
      ),
    ),
    builder: (ctx) => component,
  );

  if (isFullHeight) layoutController.subtractModalOpenCount();
  onClose?.call();
  return result;
}
