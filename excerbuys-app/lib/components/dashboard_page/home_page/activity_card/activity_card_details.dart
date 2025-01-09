import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ActivityCardDetails extends StatelessWidget {
  final bool open;
  final bool? isPurchase;
  const ActivityCardDetails({super.key, required this.open, this.isPurchase});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                      Text('Duration',
                          style: TextStyle(
                              fontSize: 14, color: colors.tertiaryContainer)),
                      Text('10min 22s',
                          style:
                              TextStyle(fontSize: 14, color: colors.tertiary))
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Distance',
                          style: TextStyle(
                              fontSize: 14, color: colors.tertiaryContainer)),
                      Text('45km',
                          style:
                              TextStyle(fontSize: 14, color: colors.tertiary))
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calories burned',
                          style: TextStyle(
                              fontSize: 14, color: colors.tertiaryContainer)),
                      Text('132',
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
                              ? 'View transaction details'
                              : 'View training details',
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
                              '122 \$',
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
