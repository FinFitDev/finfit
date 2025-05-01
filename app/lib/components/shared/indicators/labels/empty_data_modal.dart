import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class EmptyDataModal extends StatelessWidget {
  final String? message;
  const EmptyDataModal({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text(
                    message ?? "No data available",
                    textAlign: TextAlign.start,
                    style: texts.headlineLarge,
                  ),
                ),
                Text(
                  textAlign: TextAlign.start,
                  "Close the modal and try again",
                  style: TextStyle(
                    color: colors.primaryFixedDim,
                  ),
                ),
              ],
            ),
          ),
          MainButton(
              label: 'Close',
              backgroundColor: colors.tertiaryContainer.withAlpha(80),
              textColor: colors.primaryFixedDim,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}
