import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontFamily: 'CarterOne',
                      fontSize: 48,
                      color: Theme.of(context).colorScheme.tertiary,
                      letterSpacing: 8),
                  children: [
                TextSpan(
                    text: 'F',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                TextSpan(
                    text: 'in',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    )),
                TextSpan(
                    text: 'F',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                TextSpan(
                    text: 'it',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ))
              ])),
          Text(
            l10n.textLogoTagline,
            style: TextStyle(
                fontFamily: 'Calligraffiti',
                fontSize: 16,
                color: Theme.of(context).colorScheme.primaryFixedDim,
                letterSpacing: 3),
          ),
        ],
      ),
    );
  }
}
