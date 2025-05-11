import 'dart:math';

import 'package:excerbuys/components/shared/indicators/circle_progress/load_more_indicator.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class InfiniteListWrapperV2 extends StatefulWidget {
  final bool on;
  final EdgeInsets? padding;
  final List<Widget> children;
  final bool? isLoadingMoreData;
  final bool? isRefreshing;
  final bool? canFetchMore;
  final void Function()? onLoadMore;
  final void Function()? onRefresh;
  const InfiniteListWrapperV2(
      {super.key,
      required this.on,
      this.padding,
      required this.children,
      this.isLoadingMoreData,
      this.isRefreshing,
      this.canFetchMore,
      this.onLoadMore,
      this.onRefresh});

  @override
  State<InfiniteListWrapperV2> createState() => _InfiniteListWrapperV2State();
}

class _InfiniteListWrapperV2State extends State<InfiniteListWrapperV2>
    with TickerProviderStateMixin {
  final ValueNotifier<double> scrollMoreProgress = ValueNotifier(0.0);
  final ValueNotifier<double> refreshProgress = ValueNotifier(0.0);

  final ValueNotifier<bool> isScrolling = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;

  void setLoadMoreDataProgressIndicator() {
    if (!_scrollController.hasClients) return;

    if (widget.canFetchMore != true ||
        widget.isLoadingMoreData == true ||
        widget.isRefreshing == true) {
      return;
    }

    scrollMoreProgress.value = (_scrollController.position.pixels -
        _scrollController.position.maxScrollExtent);
  }

  void setRefreshProgress() {
    if (!_scrollController.hasClients) return;

    if (widget.isRefreshing == true) {
      return;
    }

    refreshProgress.value = -(_scrollController.position.pixels + 50);
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
  void didUpdateWidget(covariant InfiniteListWrapperV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ensure ScrollController is attached before accessing position
    if (mounted && _scrollController.hasClients) {
      _scrollController.removeListener(setLoadMoreDataProgressIndicator);
      _scrollController.removeListener(setRefreshProgress);

      if (widget.on) {
        _scrollController.addListener(setLoadMoreDataProgressIndicator);
        _scrollController.addListener(setRefreshProgress);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(setLoadMoreDataProgressIndicator);
    _scrollController.removeListener(setRefreshProgress);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
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
          } else if (refreshProgress.value > 100) {
            triggerVibrate(FeedbackType.light);
            if (widget.isRefreshing == false) {
              refreshProgress.value = 0;
              widget.onRefresh?.call();
            }
          }
        },
        onPointerDown: (event) {
          isScrolling.value = true;
        },
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            padding: widget.padding ?? EdgeInsets.all(0),
            itemCount: widget.children.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return widget.on && !widget.isRefreshing!
                    ? ValueListenableBuilder<double>(
                        valueListenable: refreshProgress,
                        builder: (context, value, child) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: LoadMoreIndicator(
                              scrollLoadMoreProgress: min(max(value, 0), 100),
                              disableText: true,
                            ),
                          );
                        })
                    : SizedBox(
                        height: 78,
                      );
              }

              if (index == widget.children.length + 1) {
                return widget.on && !widget.isRefreshing!
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
                    : SizedBox.shrink();
              }
              return widget.children[index - 1];
            }));
  }
}
