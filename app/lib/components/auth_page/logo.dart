import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Fitness is your currency',
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
