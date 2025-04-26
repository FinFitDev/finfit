import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class RadioButton<T> extends StatelessWidget {
  final T value;
  final T? activeValue;
  final String label;
  final bool? disabled;
  final void Function(T?) onChanged;
  const RadioButton(
      {super.key,
      required this.value,
      required this.activeValue,
      required this.onChanged,
      required this.label,
      this.disabled});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Opacity(
      opacity: disabled == true
          ? 0.2
          : activeValue != value
              ? 0.5
              : 1,
      child: Row(children: [
        Radio<T>(
          value: value,
          groupValue: activeValue,
          onChanged: (T? val) {
            if (disabled == true) return;
            triggerVibrate(FeedbackType.selection);
            onChanged(val);
          },
          activeColor: colors.secondary,

          visualDensity: VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity), // Tighter size
        ),
        GestureDetector(
          onTap: () {
            if (disabled == true) return;
            triggerVibrate(FeedbackType.selection);
            onChanged(value);
          },
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: activeValue == value && disabled != true
                    ? colors.secondary
                    : colors.primaryFixed),
          ),
        ),
      ]),
    );
  }
}
