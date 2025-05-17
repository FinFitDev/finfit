import 'dart:async';

import 'package:flutter/material.dart';

class RefreshWrapper extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final double? edgeOffset;
  const RefreshWrapper(
      {super.key,
      required this.onRefresh,
      required this.child,
      this.edgeOffset});

  @override
  State<RefreshWrapper> createState() => _RefreshWrapperState();
}

class _RefreshWrapperState extends State<RefreshWrapper> {
  Timer? progressTimer;
  bool canRefresh = true;

  void limitRefresh() {
    if (mounted) {
      setState(() {
        canRefresh = false;
      });
    }
    // TODO change refresh timeout
    progressTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        canRefresh = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          if (canRefresh) {
            await widget.onRefresh();
            limitRefresh();
          }
        },
        edgeOffset: widget.edgeOffset ?? 16,
        color: Theme.of(context).colorScheme.secondary,
        child: widget.child);
  }
}
