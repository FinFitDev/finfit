import 'package:excerbuys/components/shared/image_component.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class StravaImportBadge extends StatelessWidget {
  const StravaImportBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 102, 7).withAlpha(20)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        spacing: 4,
        children: [
          ImageComponent(
            size: 14,
            image:
                "https://images.prismic.io/sacra/9232e343-6544-430f-aacd-ca85f968ca87_strava+logo.png?auto=compress,format",
          ),
          Text(
            l10n.textImportedBadge,
            style: TextStyle(
                fontSize: 10,
                color: const Color.fromARGB(255, 255, 110, 7),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
