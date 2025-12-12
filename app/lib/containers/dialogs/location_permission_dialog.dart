import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // smaller radius
      ),
      title: Text(
        l10n.textLocationPermissionTitle,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 16,
        children: [
          Text(
            l10n.textLocationPermissionBody,
            style: TextStyle(color: colors.primaryFixedDim),
          ),
          Text(
            l10n.textLocationPermissionSteps,
            style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
          MainButton(
              label: l10n.actionGoToSettings,
              backgroundColor: colors.secondary,
              textColor: colors.primary,
              onPressed: () async {
                await Geolocator.openAppSettings();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}
