import 'package:excerbuys/components/shared/buttons/category_button.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/history/constants.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonsSwitch extends StatelessWidget {
  final void Function(Map<String, dynamic> item) onPressed;
  const ButtonsSwitch({super.key, required this.onPressed});

  String _titleForCategory(
      AppLocalizations l10n, RECENT_DATA_CATEGORY category) {
    switch (category) {
      case RECENT_DATA_CATEGORY.WORKOUTS:
        return l10n.textHistoryWorkoutsTab;
      case RECENT_DATA_CATEGORY.TRANSACTIONS:
        return l10n.textHistoryTransactionsTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return StreamBuilder<RECENT_DATA_CATEGORY>(
        stream: historyController.activeCategoryRecentDataStream,
        builder: (context, snapshot) {
          return Container(
            height: 50,
            margin: EdgeInsets.all(16),
            width: layoutController.relativeContentWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colors.primaryFixedDim.withAlpha(20)),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0;
                      index < HISTORY_CATEGORY_BUTTONS.length;
                      index++) ...[
                    if (index > 0) const SizedBox(width: 10),
                    Expanded(
                      child: CategoryButton(
                        title: _titleForCategory(
                            l10n, HISTORY_CATEGORY_BUTTONS[index].category),
                        icon: HISTORY_CATEGORY_BUTTONS[index].icon,
                        activeBackgroundColor: colors.primary,
                        backgroundColor: Colors.transparent,
                        activeTextColor: colors.tertiary,
                        textColor: colors.primaryFixedDim,
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onPressed: () {
                          onPressed({
                            'category':
                                HISTORY_CATEGORY_BUTTONS[index].category,
                          });
                        },
                        fontSize: 13,
                        isActive: snapshot.data ==
                            HISTORY_CATEGORY_BUTTONS[index].category,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        });
  }
}
