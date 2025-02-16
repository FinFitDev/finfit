import 'package:excerbuys/components/dashboard_page/home_page/activity_card/activity_card_details.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityCard extends StatefulWidget {
  final ACTIVITY_TYPE activityType;
  final int points;
  final String date;
  final bool? isPurchase;
  final int? calories;
  final int? duration;
  final int index;

  const ActivityCard({
    super.key,
    required this.activityType,
    required this.date,
    required this.points,
    this.isPurchase,
    required this.index,
    this.calories,
    this.duration,
  });

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

    return RippleWrapper(
      onPressed: () {
        setState(() {
          _detailsOpen = !_detailsOpen;
        });
      },
      child: Container(
        height: 70,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            widget.isPurchase == true
                ? SizedBox(
                    height: 36,
                  )
                : Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(
                            255,
                            (colors.secondary.r *
                                    255 /
                                    (1 + widget.index * 0.1))
                                .round(),
                            (colors.secondary.g *
                                    255 /
                                    (1 + widget.index * 0.1))
                                .round(),
                            (colors.secondary.b *
                                    255 /
                                    (1 + widget.index * 0.1))
                                .round())),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 23,
                          child: SvgPicture.asset(activityMetadata.icon,
                              colorFilter: ColorFilter.mode(
                                  colors.primary, BlendMode.srcIn)),
                        ),
                        Text(
                          activityMetadata.name,
                          style: TextStyle(fontSize: 7, color: colors.primary),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: StreamBuilder<bool>(
                            stream: dashboardController.balanceHiddenStream,
                            builder: (context, snapshot) {
                              final bool isHidden = snapshot.data ?? false;
                              return Text(
                                isHidden
                                    ? '***** finpoints'
                                    : '${widget.points.abs().toString()} finpoints',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                      ),
                      Text(
                        widget.date
                            .split(' ')[widget.date.split(' ').length - 1],
                        style: TextStyle(
                            color: colors.tertiaryContainer, fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${convertMillisecondsToMinutes(widget.duration ?? 0).round()} min',
                        style: TextStyle(
                          color: colors.tertiaryContainer,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      SvgPicture.asset('assets/svg/clock.svg',
                          colorFilter: ColorFilter.mode(
                              colors.tertiaryContainer, BlendMode.srcIn)),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${widget.calories} kcal',
                        style: TextStyle(
                          color: colors.tertiaryContainer,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      SvgPicture.asset('assets/svg/fire.svg',
                          colorFilter: ColorFilter.mode(
                              colors.tertiaryContainer.withAlpha(150),
                              BlendMode.srcIn))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
