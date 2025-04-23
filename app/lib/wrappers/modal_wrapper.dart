import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

Future<T?> openModal<T>(BuildContext context, Widget component) {
  FocusScope.of(context).requestFocus(FocusNode());

  return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MODAL_BORDER_RADIUS),
        ),
      ),
      builder: (ctx) => component);
}
