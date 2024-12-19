import 'dart:ui';

import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.sizeOf(context).width,
          color: Colors.black.withOpacity(0.6),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RippleWrapper(
                onPressed: () {},
                child: Container(
                  child: SvgPicture.asset(
                    'assets/svg/menu.svg',
                    height: 35,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.tertiary,
                        BlendMode.srcIn),
                  ),
                ),
              ),
              Row(children: [
                RippleWrapper(
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        child: SvgPicture.asset(
                          'assets/svg/shopping-basket.svg',
                          height: 28,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.tertiary,
                              BlendMode.srcIn),
                        ),
                      ),
                      Positioned(
                          left: 5,
                          top: 9,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.secondary),
                          )),
                    ],
                  ),
                ),
                RippleWrapper(
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 7),
                        child: SvgPicture.asset(
                          'assets/svg/bell.svg',
                          height: 25,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.tertiary,
                              BlendMode.srcIn),
                        ),
                      ),
                      Positioned(
                          left: 8,
                          top: 7,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.secondary),
                          )),
                    ],
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
