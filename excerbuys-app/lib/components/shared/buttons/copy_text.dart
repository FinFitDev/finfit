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
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: widget.textToCopy));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.primaryContainer),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.textToCopy,
              style: TextStyle(
                  fontSize: 12,
                  color: colors.primaryFixedDim,
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
