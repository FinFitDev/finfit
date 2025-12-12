import 'dart:io';
import 'dart:math';
import 'package:excerbuys/store/controllers/app_controller/app_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _pulseAnimation;
  late Animation<double> _wiggleAnimation;

  void loadApp() async {
    await appController.getDeviceId();
    await appController.getInstallTimestamp();
    await appController.restoreStateFromStorage();

    final String refreshToken = authController.refreshToken;
    final User? currentUser = userController.currentUser;

    Future.delayed(const Duration(seconds: 1), () {
      if (refreshToken.isNotEmpty && currentUser != null) {
        navigateWithClear(route: '/dashboard');
      } else {
        navigateWithClear(route: '/welcome');
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Pulse: 0.95 → 1.1 scale
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Wiggle: small rotation: -5° → +5°
    _wiggleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -0.1, end: 0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.1, end: -0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    loadApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    layoutController.setStatusBarHeight(MediaQuery.of(context).padding.top);

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _wiggleAnimation.value,
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Optional loading text
            Text(
              l10n.loading,
              style: TextStyle(
                color: colors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
