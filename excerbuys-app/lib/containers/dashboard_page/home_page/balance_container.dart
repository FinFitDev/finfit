import 'dart:math';

import 'package:excerbuys/components/animated_balance.dart';
import 'package:excerbuys/components/shared/indicators/ellipse/ellipse_painter.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BalanceContainer extends StatefulWidget {
  final int balance;
  const BalanceContainer({super.key, required this.balance});

  @override
  State<BalanceContainer> createState() => _BalanceContainerState();
}

class _BalanceContainerState extends State<BalanceContainer> {
  int _balance = 0;

  @override
  void initState() {
    setState(() {
      _balance = widget.balance;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          left: -270,
          top: -70,
          child: CustomPaint(
            size: Size(800, 310),
            painter: EllipsePainter(color: colors.secondary.withAlpha(100)),
          ),
        ),
        Positioned(
          left: -300,
          top: -100,
          child: CustomPaint(
            size: Size(800, 310),
            painter: EllipsePainter(color: colors.secondary.withAlpha(100)),
          ),
        ),
        Positioned(
          left: -200,
          top: -100,
          child: CustomPaint(
            size: Size(700, 290),
            painter: EllipsePainter(color: colors.primary),
          ),
        ),
        Container(
          height: 250,
          padding: EdgeInsets.symmetric(
              horizontal: HORIZOTAL_PADDING * 2, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBalance(balance: _balance),
                    Text(
                      'fitness points',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              RippleWrapper(
                onPressed: () {
                  setState(() {
                    Random random = Random();
                    _balance = max(_balance + random.nextInt(1000) - 500, 0);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 60),
                  child: SvgPicture.asset(
                    'assets/svg/info.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.tertiary,
                        BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
