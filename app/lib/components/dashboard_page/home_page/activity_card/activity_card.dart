import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/workout_info_modal.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/home/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityCard extends StatefulWidget {
  final void Function() onPressed;
  final ACTIVITY_TYPE activityType;
  final int points;
  final String date;
  final bool? isPurchase;
  final int? calories;
  final int? duration;

  const ActivityCard({
    super.key,
    required this.activityType,
    required this.date,
    required this.points,
    this.isPurchase,
    this.calories,
    this.duration,
    required this.onPressed,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _detailsOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final ActivityMetadata activityMetadata =
        getActivityMetadata(widget.activityType);
    final color = widget.points >= 0 ? colors.secondary : colors.error;

    return RippleWrapper(
      onPressed: () {
        widget.onPressed();
      },
      child: Container(
        height: 75,
        padding: EdgeInsets.all(10),
        color: Colors.transparent,
        child: Row(
          children: [
            widget.isPurchase == true
                ? SizedBox(
                    height: 36,
                  )
                : ActivityIcon(icon: activityMetadata.icon, size: 50),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                  style: texts.headlineMedium?.copyWith(
                                    color: color,
                                  ));
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
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        parseDuration(widget.duration ?? 0),
                        style: TextStyle(
                          color: colors.tertiaryContainer,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: 0.5,
                        height: 16,
                        color: colors.tertiaryContainer,
                      ),
                      Text(
                        '${widget.calories} kcal',
                        style: TextStyle(
                          color: colors.tertiaryContainer,
                          fontSize: 13,
                        ),
                      ),

                      // SvgPicture.asset('assets/svg/fire.svg',
                      //     colorFilter: ColorFilter.mode(
                      //         colors.tertiaryContainer.withAlpha(150),
                      //         BlendMode.srcIn))
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
