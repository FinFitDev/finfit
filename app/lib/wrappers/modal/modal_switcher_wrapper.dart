import 'package:flutter/material.dart';

typedef ModalStepBuilder = Widget Function(
    VoidCallback nextPage, VoidCallback previousPage, Function(int) customPage);

class ModalStep extends StatelessWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(int) customPage;
  final Widget child;

  const ModalStep({
    super.key,
    required this.child,
    required this.nextPage,
    required this.previousPage,
    required this.customPage,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ModalSwitcherWrapper extends StatefulWidget {
  final List<ModalStepBuilder> modals;
  const ModalSwitcherWrapper({super.key, required this.modals});

  @override
  State<ModalSwitcherWrapper> createState() => _ModalSwitcherWrapperState();
}

class _ModalSwitcherWrapperState extends State<ModalSwitcherWrapper> {
  int _currentStep = 0;

  void nextPage() {
    setState(() {
      if (_currentStep < widget.modals.length - 1) _currentStep++;
    });
  }

  void previousPage() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  void customPage(int page) {
    setState(() {
      if (page >= 0 && page < widget.modals.length) {
        _currentStep = page;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.decelerate,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
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
      child: Container(
        key: ValueKey(_currentStep),
        child: widget.modals[_currentStep](nextPage, previousPage, customPage),
      ),
    );
  }
}
