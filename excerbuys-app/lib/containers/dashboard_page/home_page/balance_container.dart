import 'dart:async';
import 'dart:math';

import 'package:excerbuys/components/animated_balance.dart';
import 'package:excerbuys/components/shared/indicators/ellipse/ellipse_painter.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class BalanceContainer extends StatefulWidget {
  final int balance;
  const BalanceContainer({super.key, required this.balance});

  @override
  State<BalanceContainer> createState() => _BalanceContainerState();
}

class _BalanceContainerState extends State<BalanceContainer> {
  int _balance = 200;

  @override
  void initState() {
    setState(() {
      _balance = widget.balance;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BalanceContainer oldWidget) {
    setState(() {
      _balance = widget.balance;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height - 100,
      color: colors.primaryFixed,
      child: Stack(
        children: [
          Positioned(child: RiveAnimation.asset('assets/rive/blobs.riv')),
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.only(
                left: HORIZOTAL_PADDING * 2,
                right: HORIZOTAL_PADDING * 2,
                top: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedBalance(balance: _balance),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'fitness points',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Quicksand'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
