import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class EmptyDataModal extends StatelessWidget {
  final String? message;
  const EmptyDataModal({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final l10n = context.l10n;
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
                    message ?? l10n.textEmptyStateTitle,
                    textAlign: TextAlign.start,
                    style: texts.headlineLarge,
                  ),
                ),
                Text(
                  textAlign: TextAlign.start,
                  l10n.textEmptyStateDescription,
                  style: TextStyle(
                    color: colors.primaryFixedDim,
                  ),
                ),
              ],
            ),
          ),
          MainButton(
              label: l10n.actionClose,
              backgroundColor: colors.tertiaryContainer.withAlpha(80),
              textColor: colors.primaryFixedDim,
              onPressed: () {
                closeModal(context);
              })
        ],
      ),
    );
  }
}
