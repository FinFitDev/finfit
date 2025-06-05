import 'package:excerbuys/components/shared/list/list_entry.dart';
import 'package:flutter/material.dart';

class ListComponent extends StatelessWidget {
  final Map<String, Object> data;
  final String? summary;
  final Color? summaryColor;

  const ListComponent(
      {super.key, required this.data, this.summary, this.summaryColor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.primaryContainer),
        child: Wrap(
          children: [
            ...data.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == data.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListEntry(
                      title: item.key,
                      label: item.value is String ? item.value as String : null,
                      component:
                          item.value is Widget ? item.value as Widget : null,
                    ),
                  ),
                  if (!isLast ||
                      summary !=
                          null) // ✅ only show divider if not last OR summary is not null
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 2,
                      color: colors.primary,
                    ),
                ],
              );
            }),
            summary != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListEntry(
                      title: 'Summary',
                      label: summary!,
                      textColor: summaryColor,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ));
  }
}
