import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RangeSliderComponent extends StatefulWidget {
  final String label;
  final SfRangeValues? values;
  final Map<String, double> range;
  final double? stepSize;
  final String? suffix;
  final void Function(SfRangeValues) onChanged;
  const RangeSliderComponent(
      {super.key,
      required this.label,
      this.values,
      required this.range,
      this.suffix,
      required this.onChanged,
      this.stepSize});

  @override
  State<RangeSliderComponent> createState() => _RangeSliderComponentState();
}

class _RangeSliderComponentState extends State<RangeSliderComponent> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colors.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${(formatNumber((widget.values?.start as num).round()))} ${widget.suffix ?? ''} - ${formatNumber((widget.values?.end as num).round())} ${widget.suffix ?? ''}',
                  style: TextStyle(
                      color: colors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SfRangeSlider(
            min: widget.range['min'] ?? 0.0,
            max: widget.range['max'] ?? 10.0,
            values: widget.values ??
                SfRangeValues(
                  widget.range['min'] ?? 0.0,
                  widget.range['max'] ?? 10.0,
                ),
            stepSize: widget.stepSize ?? 1,
            activeColor: colors.secondary,
            inactiveColor: colors.secondary.withAlpha(50),
            thumbShape: SfThumbShape(),
            onChanged: (SfRangeValues newValues) {
              triggerVibrate(FeedbackType.selection);
              widget.onChanged(newValues);
            },
          ),
        ],
      ),
    );
  }
}
