import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Postition extends StatefulWidget {
  final String label;
  final String? iconLeft;
  final String? iconRight;
  final void Function() onPressed;
  final Color? color;
  final bool? disableleftIconColorFilter;
  const Postition(
      {super.key,
      required this.label,
      this.iconLeft,
      this.iconRight,
      required this.onPressed,
      this.color,
      this.disableleftIconColorFilter});

  @override
  State<Postition> createState() => _PostitionState();
}

class _PostitionState extends State<Postition> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: widget.onPressed,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.primaryContainer),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            widget.iconLeft != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(widget.iconLeft!,
                        width: 24,
                        height: 24,
                        colorFilter: widget.disableleftIconColorFilter == true
                            ? null
                            : ColorFilter.mode(
                                widget.color ?? colors.primaryFixedDim,
                                BlendMode.srcIn)),
                  )
                : SizedBox.shrink(),
            Expanded(
              child: Text(widget.label,
                  style: TextStyle(
                      color: widget.color ?? colors.primaryFixedDim,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ),
            widget.iconRight != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SvgPicture.asset(widget.iconRight!,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                            widget.color ?? colors.primaryFixedDim,
                            BlendMode.srcIn)),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
