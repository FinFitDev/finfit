import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'excerbuys',
            style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: 48,
                color: Theme.of(context).colorScheme.tertiary,
                letterSpacing: 5),
          ),
          Container(
            margin: EdgeInsets.only(left: 50),
            child: Text(
              'Fitness is your currency',
              style: TextStyle(
                  fontFamily: 'Blinker',
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
