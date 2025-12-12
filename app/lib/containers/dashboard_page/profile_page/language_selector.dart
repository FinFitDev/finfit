// This widget could live on a settings page or anywhere in your app.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Needed for supportedLocales

// Assuming the code you provided above is in main.dart
import 'package:excerbuys/main.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get a reference to the top-level state manager
    final appState = FinFitApp.of(context);

    // Safety check, though appState should not be null here
    if (appState == null) {
      return const SizedBox.shrink();
    }

    // Get the currently active locale for highlighting
    final currentLocale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Language:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        // 2. Map over the supported locales to create buttons
        ...AppLocalizations.supportedLocales.map((locale) {
          String languageName = '';

          // Determine a user-friendly name for the language code
          if (locale.languageCode == 'en') {
            languageName = 'English';
          } else if (locale.languageCode == 'pl') {
            languageName = 'Polski'; // Assuming you have an ARB file for 'pl'
          } else if (locale.languageCode == 'es') {
            languageName = 'Español'; // Based on your previous example
          }

          final isSelected = currentLocale.languageCode == locale.languageCode;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ElevatedButton(
              onPressed: () {
                // 3. Call the updateLocale method in the root widget
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? const Color(0xFF53AFF5) : Colors.grey[200],
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                elevation: isSelected ? 4 : 1,
              ),
              child: Text(languageName),
            ),
          );
        }).toList(),
      ],
    );
  }
}
