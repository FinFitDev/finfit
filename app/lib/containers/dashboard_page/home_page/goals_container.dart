import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_indicator.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class GoalsContainer extends StatefulWidget {
  final bool? isLoading;
  const GoalsContainer({super.key, this.isLoading});

  @override
  State<GoalsContainer> createState() => _GoalsContainerState();
}

class _GoalsContainerState extends State<GoalsContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 2 * HORIZOTAL_PADDING, horizontal: HORIZOTAL_PADDING),
      padding: EdgeInsets.all(10),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colors.primaryContainer,
      ),
      child: Row(
        children: [
          CircleProgress(
            size: 50,
            progress: 0.3,
            color: colors.secondary,
          ),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily goals', style: texts.headlineMedium),
              SizedBox(height: 4),
              Text('120 out of 500 finpoints',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: colors.secondary))
            ],
          ),
        ],
      ),
    );
  }
}
