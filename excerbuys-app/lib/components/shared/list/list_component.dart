import 'package:excerbuys/components/shared/list/list_entry.dart';
import 'package:flutter/material.dart';

class ListComponent extends StatelessWidget {
  final Map<String, String> data;
  final String summary;
  final Color summaryColor;

  const ListComponent(
      {super.key,
      required this.data,
      required this.summary,
      required this.summaryColor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colors.primaryContainer),
        child: Wrap(
          runSpacing: 8,
          children: [
            ...data.entries.map((entry) {
              return ListEntry(title: entry.key, label: entry.value);
            }).toList(),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 0.5, color: colors.tertiaryContainer))),
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    summary,
                    style: TextStyle(
                        fontSize: 16,
                        color: summaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
