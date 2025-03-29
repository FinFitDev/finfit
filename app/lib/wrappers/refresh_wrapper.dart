import 'dart:async';

import 'package:flutter/material.dart';

class RefreshWrapper extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const RefreshWrapper(
      {super.key, required this.onRefresh, required this.child});

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
        edgeOffset: 16,
        color: Theme.of(context).colorScheme.secondary,
        child: widget.child);
  }
}
