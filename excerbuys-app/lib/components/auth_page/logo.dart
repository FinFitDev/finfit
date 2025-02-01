import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'finfit',
            style: TextStyle(
                fontFamily: 'BrunoAce',
                fontSize: 48,
                color: Theme.of(context).colorScheme.tertiary,
                letterSpacing: 5),
          ),
          Container(
            child: Text(
              'Fitness is your currency',
              style: TextStyle(
                  fontFamily: 'BrunoAce',
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 3),
            ),
          )
        ],
      ),
    );
  }
}
