import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_indicator.dart';
import 'package:flutter/material.dart';

class LoadMoreIndicator extends StatelessWidget {
  final double? scrollLoadMoreProgress;
  final String? text;
  final bool? disableText;

  const LoadMoreIndicator(
      {super.key, this.scrollLoadMoreProgress, this.text, this.disableText});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Opacity(
      opacity: (scrollLoadMoreProgress ?? 0) / 100,
      child: Column(
        children: [
          CircleProgress(
            size: 30,
            progress: (scrollLoadMoreProgress ?? 0) / 100,
            color: colors.secondary,
          ),
          SizedBox(
            height: 8,
          ),
          disableText != true
              ? Text(
                  text ?? 'Load more data',
                  style: TextStyle(fontSize: 13, color: colors.secondary),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
