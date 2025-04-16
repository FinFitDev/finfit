import 'dart:math';

import 'package:excerbuys/components/shared/indicators/circle_progress/load_more_indicator.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class InfiniteListWrapper extends StatefulWidget {
  final bool on;
  final EdgeInsets? padding;
  final Widget child;
  final bool? isLoadingMoreData;
  final bool? isRefreshing;
  final bool? canFetchMore;
  final void Function()? onLoadMore;
  final void Function()? onRefresh;
  const InfiniteListWrapper(
      {super.key,
      required this.on,
      this.padding,
      required this.child,
      this.isLoadingMoreData,
      this.isRefreshing,
      this.canFetchMore,
      this.onLoadMore,
      this.onRefresh});

  @override
  State<InfiniteListWrapper> createState() => _InfiniteListWrapperState();
}

class _InfiniteListWrapperState extends State<InfiniteListWrapper>
    with TickerProviderStateMixin {
  final ValueNotifier<double> scrollMoreProgress = ValueNotifier(0.0);
  final ValueNotifier<bool> isScrolling = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;

  void setLoadMoreDataProgressIndicator() {
    if (!_scrollController.hasClients) return;

    if (widget.canFetchMore != true || widget.isLoadingMoreData == true) {
      return;
    }

    scrollMoreProgress.value = (_scrollController.position.pixels -
        _scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.repeat();
  }

  @override
  void didUpdateWidget(covariant InfiniteListWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Ensure ScrollController is attached before accessing position
    if (mounted && _scrollController.hasClients) {
      _scrollController.removeListener(setLoadMoreDataProgressIndicator);
      if (widget.on) {
        _scrollController.addListener(setLoadMoreDataProgressIndicator);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(setLoadMoreDataProgressIndicator);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Listener(
      onPointerUp: (event) {
        isScrolling.value = false;

        if (!widget.on) {
          return;
        }
        // if the progress indicator for load more data is full and we relase the scrollview
        if (scrollMoreProgress.value > 100) {
          triggerVibrate(FeedbackType.light);
          if (widget.canFetchMore == true) {
            scrollMoreProgress.value = 0;
            widget.onLoadMore?.call();
          }
        } else if (_scrollController.position.pixels < -50) {}
      },
      onPointerDown: (event) {
        isScrolling.value = true;
      },
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          padding: widget.padding ?? EdgeInsets.all(0),
          child: Column(
            children: [
              widget.child,
              widget.on
                  ? Container(
                      margin: EdgeInsets.only(
                          top: widget.isLoadingMoreData == true ? 20 : 0,
                          bottom: widget.isLoadingMoreData == true ? 40 : 0),
                      child: widget.isLoadingMoreData == true
                          ? SpinKitCircle(
                              color: colors.secondary,
                              size: 30.0,
                              controller: _animationController,
                            )
                          : widget.canFetchMore == true
                              ? ValueListenableBuilder<double>(
                                  valueListenable: scrollMoreProgress,
                                  builder: (context, value, child) {
                                    return LoadMoreIndicator(
                                      scrollLoadMoreProgress:
                                          min(max(value, 0), 100),
                                    );
                                  })
                              : SizedBox.shrink(),
                    )
                  : SizedBox.shrink(),
            ],
          )),
    );
  }
}
