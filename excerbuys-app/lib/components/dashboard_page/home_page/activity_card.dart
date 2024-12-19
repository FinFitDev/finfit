import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityCard extends StatefulWidget {
  final ACTIVITY_TYPE activityType;
  final int points;
  final String date;
  final bool? isFirst;

  const ActivityCard(
      {super.key,
      required this.activityType,
      required this.date,
      required this.points,
      this.isFirst});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _detailsOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ActivityMetadata activityMetadata =
        getActivityMetadata(widget.activityType);
    final color = widget.points >= 0 ? colors.secondary : colors.error;

    return Column(
      children: [
        RippleWrapper(
          onPressed: () {
            setState(() {
              _detailsOpen = !_detailsOpen;
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: widget.isFirst == true ? 12 : 3),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: SvgPicture.asset(activityMetadata.icon,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 12),
                  height: 36,
                  width: 1,
                  color: color,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6),
                            child: Text(
                              widget.points.abs().toString(),
                              style: TextStyle(color: color, fontSize: 15),
                            ),
                          ),
                          Text(
                            '(${widget.date})',
                            style: TextStyle(
                                color: colors.tertiaryContainer, fontSize: 11),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6),
                            child: Text(
                              activityMetadata.name,
                              style: TextStyle(
                                  color: colors.tertiary, fontSize: 11),
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: _detailsOpen ? 2 : 0,
                            child: SvgPicture.asset('assets/svg/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                    colors.tertiary, BlendMode.srcIn)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 8),
          curve: Curves.decelerate,
          duration: Duration(milliseconds: 200),
          height: _detailsOpen ? 150 : 0,
          decoration: BoxDecoration(
              color: colors.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        )
      ],
    );
  }
}
