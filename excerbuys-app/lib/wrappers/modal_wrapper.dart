import 'package:flutter/material.dart';

Future<T?> openModal<T>(BuildContext context, Widget component) {
  return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0),
        ),
      ),
      builder: (ctx) => component);
}
