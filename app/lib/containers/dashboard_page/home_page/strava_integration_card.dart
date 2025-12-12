import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/store/controllers/activity/strava_controller/strava_controller.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class StravaIntegrationCard extends StatelessWidget {
  const StravaIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return RippleWrapper(
      onPressed: () {
        stravaController.authorize();
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
          color: colors.primary,
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 254, 91, 9),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 0.5, color: colors.primaryContainer)),
          child: Row(
            spacing: 16,
            children: [
              Stack(
                children: [
                  ImageComponent(
                    size: 40,
                    image:
                        "https://images.prismic.io/sacra/9232e343-6544-430f-aacd-ca85f968ca87_strava+logo.png?auto=compress,format",
                  ),
                  Positioned(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colors.primary.withAlpha(60),
                    ),
                    width: 40,
                    height: 40,
                  )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    l10n.textStravaConnect,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.primary),
                  ),
                  Text(
                    l10n.textStravaSync,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colors.primaryContainer),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
