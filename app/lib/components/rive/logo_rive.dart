import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LogoRive extends StatelessWidget {
  const LogoRive({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 100,
          child: Opacity(
            opacity: 0.2,
            child: SizedBox(
                height: 180,
                width: 180,
                child: Transform.rotate(
                  angle: 0.1,
                  child: RiveAnimation.asset(
                    'assets/rive/dolphin.riv',
                    fit: BoxFit.contain,
                  ),
                )),
          ),
        ),
        Positioned(
          child: Container(
              margin: EdgeInsets.only(top: 30),
              height: 250,
              width: 250,
              child: Transform.rotate(
                angle: 0.5,
                child: RiveAnimation.asset(
                  'assets/rive/dolphin.riv',
                  fit: BoxFit.contain,
                ),
              )),
        ),
      ],
    );
  }
}
