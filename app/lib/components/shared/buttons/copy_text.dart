import 'dart:async';

import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CopyText extends StatefulWidget {
  final String textToCopy;
  const CopyText({super.key, required this.textToCopy});

  @override
  State<CopyText> createState() => _CopyTextState();
}

class _CopyTextState extends State<CopyText> {
  String _text = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _text = widget.textToCopy;
    });
  }

  @override
  void didUpdateWidget(covariant CopyText oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _text = widget.textToCopy;
    });
  }

  void onCopy() async {
    Clipboard.setData(ClipboardData(text: widget.textToCopy));
    if (_text == 'Copied!') {
      return;
    }

    setState(() {
      _text = 'Copied!';
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _text = widget.textToCopy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: () {
        onCopy();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.primaryFixedDim.withAlpha(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _text,
              style: TextStyle(
                  fontSize: 12,
                  color: colors.tertiary,
                  fontWeight: FontWeight.w600),
            ),
            SvgPicture.asset(
              'assets/svg/copy.svg',
              height: 22,
              width: 22,
              colorFilter:
                  ColorFilter.mode(colors.primaryFixedDim, BlendMode.srcIn),
            )
          ],
        ),
      ),
    );
  }
}
