import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class CheckboxWithLabel extends StatefulWidget {
  final bool checked;
  final String label;
  final Function(bool?) onChanged;
  const CheckboxWithLabel(
      {super.key,
      required this.checked,
      required this.label,
      required this.onChanged});

  @override
  State<CheckboxWithLabel> createState() => _CheckboxWithLabelState();
}

class _CheckboxWithLabelState extends State<CheckboxWithLabel> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          checkColor: colors.primary,
          activeColor: colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide(color: colors.tertiaryContainer, width: 0.5),
          value: widget.checked,
          onChanged: widget.onChanged,
        ),
        GestureDetector(
          onTap: () => widget.onChanged(!widget.checked),
          child: Text(widget.label,
              style: TextStyle(fontSize: 14, color: colors.tertiaryContainer)),
        ),
      ],
    );
  }
}
