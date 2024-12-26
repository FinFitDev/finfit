import 'dart:math';

import 'package:excerbuys/components/animated_balance.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBalance(balance: _balance),
              Text(
                'fitness points',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              )
            ],
          ),
          RippleWrapper(
            onPressed: () {
              setState(() {
                Random random = Random();
                _balance = max(_balance + random.nextInt(1000) - 500, 0);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(),
              child: SvgPicture.asset(
                'assets/svg/info.svg',
                height: 20,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primaryFixed,
                    BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
