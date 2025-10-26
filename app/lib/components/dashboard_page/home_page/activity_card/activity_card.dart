import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/positions/strava_import_badge.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityCard extends StatefulWidget {
  final void Function() onPressed;
  final ACTIVITY_TYPE activityType;
  final int points;
  final String date;
  final int? distance;
  final int? duration;
  final int? calories;
  final bool? isStrava;

  const ActivityCard(
      {super.key,
      required this.activityType,
      required this.date,
      required this.points,
      this.distance,
      this.duration,
      required this.onPressed,
      this.calories,
      this.isStrava});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final ActivityMetadata activityMetadata =
        getActivityMetadata(widget.activityType, colors);

    return RippleWrapper(
      onPressed: () {
        widget.onPressed();
      },
      child: Container(
        height: 115,
        decoration: BoxDecoration(
          // color: colors.error,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              spreadRadius: -5,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                width: 20,
                decoration: BoxDecoration(
                  color: activityMetadata.color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 4,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconContainer(
                              icon: activityMetadata.icon,
                              size: 50,
                              iconColor: activityMetadata.color,
                              backgroundColor:
                                  activityMetadata.color.withAlpha(20),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Container(
                                      child: Text(activityMetadata.name,
                                          style: texts.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    widget.isStrava == true
                                        ? StravaImportBadge()
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: Text(widget.date,
                                          style: texts.bodyMedium?.copyWith(
                                              color: colors.tertiaryContainer)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('+${widget.points}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: activityMetadata.color)),
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Text('points',
                                  style: texts.bodyMedium?.copyWith(
                                      color: colors.tertiaryContainer)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Row(children: [
                          SvgPicture.asset(
                            'assets/svg/clock.svg',
                            width: 16,
                            colorFilter: ColorFilter.mode(
                                colors.tertiaryContainer, BlendMode.srcIn),
                          ),
                          SizedBox(width: 6),
                          Text(parseDuration(widget.duration ?? 0),
                              style: texts.bodyMedium
                                  ?.copyWith(color: colors.tertiaryContainer)),
                        ]),
                        Row(children: [
                          SvgPicture.asset(
                            'assets/svg/trend_up.svg',
                            width: 16,
                            colorFilter: ColorFilter.mode(
                                colors.tertiaryContainer, BlendMode.srcIn),
                          ),
                          SizedBox(width: 6),
                          Text(parseDistance((widget.distance ?? 0).toDouble()),
                              style: texts.bodyMedium
                                  ?.copyWith(color: colors.tertiaryContainer)),
                        ]),
                        Row(children: [
                          SvgPicture.asset(
                            'assets/svg/fire.svg',
                            width: 16,
                            colorFilter: ColorFilter.mode(
                                colors.tertiaryContainer, BlendMode.srcIn),
                          ),
                          SizedBox(width: 6),
                          Text('${widget.calories ?? 0} kcal',
                              style: texts.bodyMedium
                                  ?.copyWith(color: colors.tertiaryContainer)),
                        ]),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
