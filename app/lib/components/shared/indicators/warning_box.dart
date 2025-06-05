import 'package:flutter/material.dart';

class WarningBox extends StatelessWidget {
  final String text;
  const WarningBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colors.errorContainer.withAlpha(40),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 11,
            color: colors.errorContainer,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
