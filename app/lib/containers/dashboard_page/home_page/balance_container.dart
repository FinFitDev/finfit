import 'package:excerbuys/components/animated_balance.dart';
import 'package:excerbuys/components/shared/indicators/canvas/ellipse_painter.dart';
import 'package:excerbuys/containers/dashboard_page/modals/qrcode_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/send/send_modal.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
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
  int _balance = 200;

  @override
  void initState() {
    super.initState();

    setState(() {
      _balance = widget.balance;
    });
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

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(
            left: HORIZOTAL_PADDING * 2,
            right: HORIZOTAL_PADDING * 2,
            top: 150,
            bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<bool>(
                stream: dashboardController.balanceHiddenStream,
                builder: (context, snapshot) {
                  final bool isHidden = snapshot.data ?? false;

                  return isHidden
                      ? Text(
                          '******',
                          style: TextStyle(color: colors.primary, fontSize: 54),
                        )
                      : AnimatedBalance(balance: _balance);
                }),
            SizedBox(
              height: 10,
            ),
            Text(
              'finpoints',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  fontFamily: 'Quicksand'),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                homeTopButton(context, () {
                  if (userController.currentUser?.uuid != null) {
                    openModal(context, QrcodeModal());
                  }
                }, 'assets/svg/qrcode.svg', 'Receive'),
                SizedBox(
                  width: 20,
                ),
                homeTopButton(context, () {
                  openModal(context, SendModal());
                }, 'assets/svg/sent.svg', 'Send'),
                SizedBox(
                  width: 20,
                ),
                StreamBuilder<bool>(
                    stream: dashboardController.balanceHiddenStream,
                    builder: (context, snapshot) {
                      final bool isHidden = snapshot.data ?? false;
                      return homeTopButton(context, () {
                        dashboardController.setBalanceHidden(!isHidden);
                      },
                          isHidden
                              ? 'assets/svg/eye.svg'
                              : 'assets/svg/eye-close.svg',
                          isHidden ? 'Show' : 'Hide');
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget homeTopButton(
    BuildContext context, void Function() onPressed, String icon, String text) {
  final colors = Theme.of(context).colorScheme;
  return RippleWrapper(
    onPressed: onPressed,
    child: Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CustomPaint(
            painter: EllipsePainter(
                color: colors.primary.withAlpha(30),
                w: 50,
                h: 50,
                x: 0,
                y: 0,
                angle: 0),
            child: Center(
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}
