import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.sizeOf(context).width,
      height: 80,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RippleWrapper(
            onPressed: () {},
            child: Container(
              child: SvgPicture.asset(
                'assets/svg/menu.svg',
                height: 35,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          Row(children: [
            RippleWrapper(
              onPressed: () {},
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                    child: SvgPicture.asset(
                      'assets/svg/shopping-basket.svg',
                      height: 28,
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                            color: Colors.blue),
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
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                            color: Colors.blue),
                      )),
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}
