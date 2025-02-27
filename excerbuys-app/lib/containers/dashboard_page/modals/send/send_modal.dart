import 'package:excerbuys/containers/dashboard_page/modals/send/amount_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/send/choose_recipients_modal.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller.dart';
import 'package:flutter/material.dart';

class SendModal extends StatefulWidget {
  const SendModal({super.key});

  @override
  State<SendModal> createState() => _SendModalState();
}

class _SendModalState extends State<SendModal> {
  int _currentStep = 0; // Track current step

  void nextPage() {
    setState(() {
      if (_currentStep == 0) _currentStep++;
    });
  }

  void previousPage() {
    setState(() {
      if (_currentStep == 1) _currentStep--;
    });
  }

  @override
  void dispose() {
    super.dispose();
    sendController.resetUi();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          switchInCurve: Curves.decelerate,
          switchOutCurve: Curves.decelerate,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final slideAnimation = Tween<Offset>(
              begin: Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(animation);

            final fadeAnimation = Tween<double>(
              begin: 0.5,
              end: 1.0,
            ).animate(animation);

            final scaleAnimation = Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(animation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          child: _currentStep == 0
              ? ChooseRecipientsModal(
                  key: ValueKey(0),
                  nextPage: nextPage,
                )
              : AmountModal(key: ValueKey(1), previousPage: previousPage)),
    );
  }
}
