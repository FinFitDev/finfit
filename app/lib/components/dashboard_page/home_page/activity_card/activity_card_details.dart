import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class ActivityCardDetails extends StatelessWidget {
  final bool open;
  final bool? isPurchase;
  const ActivityCardDetails({super.key, required this.open, this.isPurchase});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return AnimatedSize(
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: open ? EdgeInsets.all(16) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: colors.primaryFixedDim.withAlpha(40),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: open
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.textDuration,
                          style: TextStyle(
                              fontSize: 14, color: colors.tertiaryContainer)),
                      Text(l10n.textUnknown,
                          style:
                              TextStyle(fontSize: 14, color: colors.tertiary))
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.textDistance,
                          style: TextStyle(
                              fontSize: 14, color: colors.tertiaryContainer)),
                      Text(l10n.textUnknown,
                          style:
                              TextStyle(fontSize: 14, color: colors.tertiary))
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.textCalories,
                          style: TextStyle(
                              fontSize: 14, color: colors.tertiaryContainer)),
                      Text(l10n.textUnknown,
                          style:
                              TextStyle(fontSize: 14, color: colors.tertiary))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    height: 1,
                    color: colors.tertiaryContainer,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RippleWrapper(
                          child: Text(
                            isPurchase == true
                                ? l10n.textViewTransactionDetails
                                : l10n.textViewTrainingDetails,
                          style: TextStyle(
                              fontSize: 14,
                              color: isPurchase == true
                                  ? colors.tertiaryContainer
                                  : colors.secondary),
                        ),
                        onPressed: () {},
                      ),
                      isPurchase == true
                          ? Text(
                              l10n.textUnknown,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: colors.tertiary,
                                  fontWeight: FontWeight.bold),
                            )
                          : SizedBox.shrink()
                    ],
                  )
                ],
              )
            : null,
      ),
    );
  }
}
