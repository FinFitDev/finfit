import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // smaller radius
      ),
      title: Text(
        'Permissions missing',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 16,
        children: [
          Text(
            'To track your workouts even when the app is closed, please allow background location access in system settings. Follow these steps after clicking the button below.',
            style: TextStyle(color: colors.primaryFixedDim),
          ),
          Text(
            'Location > Always',
            style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
          MainButton(
              label: 'Go to settings',
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
