import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height - 150,
        color: colors.primaryFixed,
        child: RiveAnimation.asset('assets/rive/blobs.riv'));
  }
}
