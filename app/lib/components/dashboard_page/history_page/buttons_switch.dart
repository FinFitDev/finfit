import 'dart:async';

import 'package:excerbuys/components/shared/buttons/category_button.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/history/constants.dart';
import 'package:flutter/material.dart';

class ButtonsSwitch extends StatelessWidget {
  final void Function(Map<String, dynamic> item) onPressed;
  const ButtonsSwitch({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<RECENT_DATA_CATEGORY>(
        stream: historyController.activeCategoryRecentDataStream,
        builder: (context, snapshot) {
          return SizedBox(
            height: 76,
            width: layoutController.relativeContentWidth,
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              itemCount: HISTORY_CATEGORY_BUTTONS.length,
              itemBuilder: (context, index) {
                final item = HISTORY_CATEGORY_BUTTONS[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 10.0),
                  child: CategoryButton(
                    title: item['title'],
                    icon: item['icon'],
                    activeBackgroundColor: colors.primaryContainer,
                    backgroundColor: colors.primary,
                    activeTextColor: colors.tertiaryContainer,
                    textColor: colors.tertiaryContainer,
                    onPressed: () {
                      onPressed(item);
                    },
                    fontSize: 13,
                    isActive: snapshot.data == item['category'],
                  ),
                );
              },
            ),
          );
        });
  }
}
